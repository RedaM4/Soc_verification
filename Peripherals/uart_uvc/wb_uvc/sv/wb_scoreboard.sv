class wb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(wb_scoreboard)

  `uvm_analysis_imp_decl(_master)
  uvm_analysis_imp_master#(n_cpu_transaction, wb_scoreboard) master_imp;
  
  `uvm_analysis_imp_decl(_slave)
  uvm_analysis_imp_slave#(n_cpu_transaction, wb_scoreboard) slave_imp;

  n_cpu_transaction master_queue[$];
  n_cpu_transaction slave_queue[$];

  int total_transactions = 0;
  int matched_transactions = 0;
  int mismatched_transactions = 0;
  int master_only_transactions = 0;
  int slave_only_transactions = 0;

  function new(string name = "wb_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_imp = new("master_imp", this);
    slave_imp = new("slave_imp", this);
  endfunction

  function void write_master(n_cpu_transaction trans);
    `uvm_info("SCOREBOARD", 
             $sformatf("MASTER RX: Addr=0x%0h Data=0x%0h Op=%s",
                      trans.address, trans.data, trans.M_STATE.name()), 
             UVM_HIGH)
    master_queue.push_back(trans);
    total_transactions++;
    compare_transactions();
  endfunction

  function void write_slave(n_cpu_transaction trans);
    `uvm_info("SCOREBOARD", 
             $sformatf("SLAVE RX: Addr=0x%0h Data=0x%0h Op=%s",
                      trans.address, trans.data, trans.M_STATE.name()), 
             UVM_HIGH)
    slave_queue.push_back(trans);
    total_transactions++;
    compare_transactions();
  endfunction

  function void compare_transactions();
    while (master_queue.size() > 0 && slave_queue.size() > 0) begin
      n_cpu_transaction master_trans = master_queue.pop_front();
      n_cpu_transaction slave_trans = slave_queue.pop_front();

      `uvm_info("SCOREBOARD", 
               $sformatf("COMPARE:\nMASTER: %s\nSLAVE:  %s",
                        master_trans.sprint(), slave_trans.sprint()), 
               UVM_HIGH)

      if (master_trans.compare(slave_trans)) begin
        matched_transactions++;
        `uvm_info("SCOREBOARD", "TRANSACTION MATCH", UVM_MEDIUM)
      end
      else begin
        mismatched_transactions++;
        `uvm_error("SCOREBOARD", 
                  $sformatf("MISMATCH:\nEXPECTED: %s\nACTUAL:   %s",
                           master_trans.sprint(), slave_trans.sprint()))
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    
    master_only_transactions = master_queue.size();
    slave_only_transactions = slave_queue.size();

    `uvm_info("SCOREBOARD", "---------------- WB SCOREBOARD REPORT ----------------", UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Transactions:    %0d", total_transactions), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Matched Transactions:  %0d", matched_transactions), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Mismatched Transactions: %0d", mismatched_transactions), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Unmatched Master Transactions: %0d", master_only_transactions), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Unmatched Slave Transactions:  %0d", slave_only_transactions), UVM_LOW)
    `uvm_info("SCOREBOARD", "--------------------------------------------------", UVM_LOW)

    if (mismatched_transactions == 0 && master_only_transactions == 0 && slave_only_transactions == 0) begin
      `uvm_info("SCOREBOARD", "*** TEST PASSED ***", UVM_NONE)
    end else begin
      `uvm_error("SCOREBOARD", "*** TEST FAILED ***")
    end
  endfunction
endclass
