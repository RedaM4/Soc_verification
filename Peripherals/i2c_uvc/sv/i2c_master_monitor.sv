class i2c_master_monitor extends uvm_monitor;

  
  virtual i2c_if vif;

  // Master Id
  int master_id;

  // This port is used to connect the monitor to the scoreboard
  uvm_analysis_port #(i2c_transaction) item_collected_port;

//declare a transaction
  i2c_transaction tr_collect;



  `uvm_component_utils_begin(i2c_master_monitor)
  `uvm_field_int(master_id, UVM_ALL_ON)
  `uvm_component_utils_end


  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction : new


  
  function void build_phase(uvm_phase phase);
    if (!i2c_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error(get_type_name(),{"virtual interface must be set for: ",get_full_name(),".vif"})
  
  endfunction: build_phase




virtual task run_phase(uvm_phase phase);

    // forever begin 
    // tr_collect = i2c_transaction::type_id::create("tr_collect");

    // collect();

    // `uvm_info(get_type_name(), $sformatf("transaction collected :\n%s",tr_collect.sprint()), UVM_HIGH)
    // //item_collected_port.write(tr_collect);
    //  end
  endtask : run_phase




//this task rebuild the transaction from the interface 
task collect();

//

endtask

 

endclass : i2c_master_monitor