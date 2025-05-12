package wb_pkg;

 import uvm_pkg::*;
 `include "uvm_macros.svh"

  typedef uvm_config_db#(virtual wb_if) wb_vif_config;

  `include "../sv/wb_transaction.sv"


  `include "../sv/wb_master_sequencer.sv"
  `include "../sv/wb_master_driver.sv"
  `include "../sv/wb_master_monitor.sv"
  `include "../sv/wb_master_agent.sv"
  `include "../sv/wb_master_seqs.sv"

  `include "../sv/wb_slave_sequencer.sv"
  `include "../sv/wb_slave_driver.sv"
  `include "../sv/wb_slave_monitor.sv"
  `include "../sv/wb_slave_agent.sv"
  `include "../sv/wb_slave_seqs.sv"

  `include "../sv/wb_env.sv"
 
endpackage : wb_pkg

