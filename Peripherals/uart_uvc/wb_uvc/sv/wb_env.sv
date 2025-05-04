class wb_env extends uvm_env;
  `uvm_component_utils(wb_env);

  wb_master_agent master_agent;
  wb_slave_agent slave_agent;

  function new(string name = "wb_env", uvm_component parent);
    super.new(name,parent); 
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent = wb_master_agent::type_id::create("master_agent",this); 
    slave_agent = wb_slave_agent::type_id::create("slave_agent",this); 
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
endclass: wb_env
