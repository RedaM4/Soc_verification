package i2c_pkg;

 import uvm_pkg::*;
 `include "uvm_macros.svh"

  typedef uvm_config_db#(virtual i2c_if) i2c_vif_config;

  `include "../sv/i2c_transaction.sv"


  `include "../sv/i2c_master_sequencer.sv"
  `include "../sv/i2c_master_driver.sv"
  `include "../sv/i2c_master_monitor.sv"
  `include "../sv/i2c_master_agent.sv"
  `include "../sv/i2c_master_seqs.sv"

  `include "../sv/i2c_slave_sequencer.sv"
  `include "../sv/i2c_slave_driver.sv"
  `include "../sv/i2c_slave_monitor.sv"
  `include "../sv/i2c_slave_agent.sv"
  `include "../sv/i2c_slave_seqs.sv"

  `include "../sv/i2c_env.sv"
 
endpackage : i2c_pkg

