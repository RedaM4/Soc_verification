class uart_tx_seqs extends uvm_sequence #(uart_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(uart_tx_seqs)

  // Constructor
  function new(string name="uart_tx_seqs");
    super.new(name);
     `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : uart_tx_seqs


class uart_1_seq extends uart_tx_seqs;
    `uvm_object_utils(uart_1_seq)
    // Constructor
    function new(string name = "uart_1_seq");
        super.new(name);
    endfunction

    // Body task
    
    //sequence
    task body();
        `uvm_info(get_type_name(), "Executing uart_1_seq sequence", UVM_LOW)
        for (bit [7:0] i =0 ;i<250 ;i++ ) begin
      `uvm_do_with(req, { req.data == i; req.parity_mode == 0; });
          
        end 

       #5000;
    endtask
endclass

class uart_base_test extends uart_tx_seqs;
  `uvm_object_utils(uart_base_test)
  function new(string name = "uart_base_test");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Sending 0xFF", UVM_LOW)
    `uvm_do_with(req, { req.data == 8'hFF; })
    #1000;
  endtask
endclass



class uart_parity_seqs extends uart_tx_seqs;
  `uvm_object_utils(uart_parity_seqs)
  function new(string name = "uart_parity_seqs");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Sending correct and incorrect parity", UVM_LOW)
    // Correct parity
    `uvm_do_with(req, { req.data == 8'h44; req.parity_mode == 1; })//mode =1 =>even
       #5000;

    // Incorrect parity
    `uvm_do_with(req, { req.data == 8'h55; req.parity_mode == 0; })//mode =0 =>odd
       #5000;
  endtask
endclass



class uart_rand_dual_send_seqs extends uart_tx_seqs;
    `uvm_object_utils(uart_rand_dual_send_seqs)
    // Constructor
    function new(string name = "uart_rand_dual_send_seqs");
        super.new(name);
    endfunction

    task body();
    bit temp ; 
        `uvm_info(get_type_name(), "Executing uart_rand_dual_send_seqs sequence", UVM_LOW)
        
        `uvm_do(req);
        temp = req.parity_mode  ;
        for (bit [7:0] i =0 ;i<10 ;i++ ) begin
      `uvm_do_with(req,{ req.parity_mode == temp; })
               #5000;
  
        end 

    endtask
endclass