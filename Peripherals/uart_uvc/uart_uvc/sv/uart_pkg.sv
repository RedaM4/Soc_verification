package uart_pkg;
  import uvm_pkg::*; // Import UVM package
  `include "uvm_macros.svh" // Include UVM macros

  typedef uvm_config_db#(virtual uart_if) uart_vif_config;

  // Include common structures first
  `include "uart_packet.sv"

  // TX components (Driver -> Monitor -> Sequencer -> Sequences -> Agent)
  `include "uart_tx_monitor.sv"
  `include "uart_tx_driver.sv"
  `include "uart_tx_sequencer.sv"
  `include "uart_tx_seqs.sv"
  `include "uart_tx_agent.sv"

  // RX components (Driver -> Monitor -> Sequencer -> Sequences -> Agent)
  `include "uart_rx_monitor.sv"
  `include "uart_rx_sequencer.sv"
  `include "uart_rx_seqs.sv"
  `include "uart_rx_driver.sv"
  `include "uart_rx_agent.sv"

  // Environment (Depends on TX and RX agents)
  `include "uart_env.sv"

endpackage : uart_pkg
