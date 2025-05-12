class wb_master_sequencer extends uvm_sequencer #(wb_transaction);

  // Master Id
  int master_id;

  `uvm_component_utils_begin(wb_master_sequencer)
  `uvm_field_int(master_id, UVM_ALL_ON)
  `uvm_component_utils_end


  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new



endclass : wb_master_sequencer


