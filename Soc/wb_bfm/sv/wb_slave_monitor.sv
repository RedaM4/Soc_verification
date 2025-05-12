class wb_slave_monitor extends uvm_monitor;

  
  virtual wb_if vif;

  // slave Id
  int slave_id;

  // This port is used to connect the monitor to the scoreboard
  uvm_analysis_port #(wb_transaction) item_collected_port;

//declare a transaction
  wb_transaction tr_collect;



  `uvm_component_utils_begin(wb_slave_monitor)
  `uvm_field_int(slave_id, UVM_ALL_ON)
  `uvm_component_utils_end


  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction : new


  
  function void build_phase(uvm_phase phase);
    if (!wb_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error(get_type_name(),{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction: build_phase




  virtual task run_phase(uvm_phase phase);

  @(negedge vif.clk);
    forever begin 
    tr_collect = wb_transaction::type_id::create("tr_collect");
    wait (vif.stb && vif.cyc);

    collect();

    `uvm_info(get_type_name(), $sformatf("transaction collected :\n%s",tr_collect.sprint()), UVM_FULL)
    item_collected_port.write(tr_collect);
     end
  endtask : run_phase




//this task rebuild the transaction from the interface 
task collect();

wait(vif.ack);
@(negedge vif.clk);
tr_collect.op_type =  vif.we ? wb_write : wb_read;
tr_collect.addr = vif.addr[1:0];
tr_collect.din = vif.din;
tr_collect.dout = vif.dout;
wait(!vif.ack);


endtask


endclass : wb_slave_monitor
