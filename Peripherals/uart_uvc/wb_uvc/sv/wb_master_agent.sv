//Done

class wb_master_agent extends uvm_agent;

//`uvm_component_utils(yapp_tx_agent); //mentioned down so we don't need to mention it again

wb_master_driver driver;
wb_master_monitor monitor;
wb_master_sequencer sequencer;

function new(string name = "wb_master_agent", uvm_component parent);
super.new(name,parent); 
`uvm_info("--AGENT_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void start_of_simulation_phase(uvm_phase phase);
super.start_of_simulation_phase(phase);
`uvm_info("--AGENT_CLASS--","START OF SIMULATION PHASE",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--AGENT_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);
if(is_active==UVM_ACTIVE)
begin
driver = wb_master_driver::type_id::create("driver",this);
sequencer=wb_master_sequencer::type_id::create("sequencer",this);
end
monitor= wb_master_monitor::type_id::create("monitor",this); //need to create monitor
endfunction


`uvm_component_utils_begin(wb_master_agent)
    `uvm_field_enum(uvm_active_passive_enum , is_active , UVM_ALL_ON)
`uvm_component_utils_end


function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
`uvm_info("--AGENT_CLASS--","INSIDE CONNECT PHASE",UVM_HIGH);

if(is_active==UVM_ACTIVE) driver.seq_item_port.connect(sequencer.seq_item_export);

endfunction


task run_phase(uvm_phase phase);
super.run_phase(phase);
`uvm_info("--AGENT_CLASS--","INSIDE RUN PHASE",UVM_HIGH);

endtask

endclass: wb_master_agent
