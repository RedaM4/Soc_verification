class demo_tb extends uvm_env;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(demo_tb)

  // i2c environment
  i2c_env i2c;

  // Constructor - required syntax for UVM automation and utilities
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // This overwrites configuration from testbench    
    uvm_config_int::set(this,"*i2c*", "num_masters", 1);
    uvm_config_int::set(this,"*i2c*", "num_slaves", 1);
    i2c = i2c_env::type_id::create("i2c", this);
  endfunction : build_phase
 

endclass : demo_tb



