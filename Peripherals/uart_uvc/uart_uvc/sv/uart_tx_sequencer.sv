class uart_tx_sequencer extends uvm_sequencer #(uart_packet);
  `uvm_component_utils(uart_tx_sequencer)

  function new(string name , uvm_component parent);
    super.new(name, parent);
        `uvm_info("SEQR_CLASS", "Inside Constructor!", UVM_HIGH)

  endfunction

endclass