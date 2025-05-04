class i2c_master_sequencer extends uvm_sequencer #(i2c_transaction);

  // Master Id
  int master_id;

  `uvm_component_utils_begin(i2c_master_sequencer)
  `uvm_field_int(master_id, UVM_ALL_ON)
  `uvm_component_utils_end


  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new



endclass : i2c_master_sequencer


