class i2c_env extends uvm_env;

// Control properties
int unsigned num_masters = 0;
int unsigned num_slaves = 0;

  // Components of the environment
  i2c_master_agent masters[];
  i2c_slave_agent  slaves[];


  `uvm_component_utils_begin(i2c_env)
    `uvm_field_int(num_masters, UVM_ALL_ON)
    `uvm_field_int(num_slaves, UVM_ALL_ON)
  `uvm_component_utils_end

  // Constructor - required syntax for UVM automation and utilities
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // Additional class methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass : i2c_env


  // UVM build_phase
  function void i2c_env::build_phase(uvm_phase phase);
  
  
  //uvm_congig_int::set(this,"tb.slaves[0].agent","is_active", UVM_PASSIVE);
   
   
   
    string inst_name;
    super.build_phase(phase);
    
    masters = new[num_masters];
      foreach(masters [i]) begin
        $sformat(inst_name, "masters[%0d]", i);
        masters[i] = i2c_master_agent::type_id::create(inst_name, this);
      end

    slaves = new[num_slaves];
    foreach(slaves [i]) begin
      $sformat(inst_name, "slaves[%0d]", i);
      slaves[i]  = i2c_slave_agent::type_id::create(inst_name, this);
    end
  endfunction : build_phase



  // UVM connect_phase
  function void i2c_env::connect_phase(uvm_phase phase);
    foreach(masters [i]) begin
      masters[i].set_master_id(i);
    end
    foreach(slaves [i]) 
      slaves[i].set_slave_id(i);
  endfunction : connect_phase


