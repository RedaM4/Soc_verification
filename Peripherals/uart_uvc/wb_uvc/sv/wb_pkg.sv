package wb_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  typedef uvm_config_db#(virtual wb_if) wb_vif_config;
  
  `include "wb_sequence_item.sv"
  `include "wb_master_sequencer.sv"
  `include "wb_slave_sequencer.sv"
  `include "wb_master_driver.sv"
  `include "wb_slave_driver.sv"
  `include "wb_master_monitor.sv"
  `include "wb_slave_monitor.sv"
  `include "wb_master_agent.sv"
  `include "wb_slave_agent.sv"
  `include "wb_master_seqs.sv"
  `include "wb_slave_seqs.sv"
  `include "wb_scoreboard.sv"
  `include "wb_env.sv"

  
endpackage
