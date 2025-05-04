class i2c_slave_sequencer extends uvm_sequencer #(i2c_transaction);

  // slave Id
  int slave_id;

  `uvm_component_utils_begin(i2c_slave_sequencer)
  `uvm_field_int(slave_id, UVM_ALL_ON)
  `uvm_component_utils_end


  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new



endclass : i2c_slave_sequencer


