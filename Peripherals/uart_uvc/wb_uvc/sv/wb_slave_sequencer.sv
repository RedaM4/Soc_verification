//DONE

class slave_sequencer extends uvm_sequencer #(n_cpu_transaction);

`uvm_component_utils(slave_sequencer);


function new(string name ="slave_sequencer", uvm_component parent);
super.new(name,parent); 
`uvm_info("--SEQUENCER_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void start_of_simulation_phase(uvm_phase phase);
super.start_of_simulation_phase(phase);

`uvm_info("--SEQUENCER_CLASS--","START OF SIMULATION PHASE",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--SEQUENCER_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);
endfunction



function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
`uvm_info("--SEQUENCER_CLASS--","INSIDE CONNECT PHASE",UVM_HIGH);
endfunction


endclass: slave_sequencer
