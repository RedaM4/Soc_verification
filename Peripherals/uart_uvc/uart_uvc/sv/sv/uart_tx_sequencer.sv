class uart_tx_sequencer extends uvm_sequencer #(uart_packet);
  `uvm_component_utils(uart_tx_sequencer)

  function new(string name , uvm_component parent);
    super.new(name, parent);
        `uvm_info("SEQR_CLASS", "Inside Constructor!", UVM_HIGH)

  endfunction

  // function void start_of_simulation_phase(uvm_phase phase);
  //    `uvm_info("SEQR_CLASS", "start of simulation phase", UVM_HIGH)
  // endfunction
endclass