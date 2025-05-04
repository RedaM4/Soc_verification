
class i2c_slave_driver extends uvm_driver #(i2c_transaction);

  virtual i2c_if vif;

  // slave Id
  int slave_id;


  `uvm_component_utils_begin(i2c_slave_driver)
    `uvm_field_int(slave_id, UVM_DEFAULT)
  `uvm_component_utils_end

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!i2c_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error(get_type_name(),{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction: build_phase



  // run_phase
  virtual task run_phase(uvm_phase phase);

    // forever begin

    // end

    
  endtask : run_phase

endclass : i2c_slave_driver


