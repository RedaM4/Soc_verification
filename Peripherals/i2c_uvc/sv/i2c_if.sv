interface i2c_if (input bit clk, input bit rst_n);
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import i2c_pkg::*;

//signals



task  send_to_dut (i2c_transaction tr);


endtask :send_to_dut


task  responsd_to_master ();


endtask :responsd_to_master



endinterface : i2c_if

