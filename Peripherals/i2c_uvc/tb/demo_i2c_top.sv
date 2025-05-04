`timescale 1ns/1ns

module demo_top;

  // UVM class library compiled in a package
  import uvm_pkg::*;

  // Bring in the rest of the library (macros and template classes)
  `include "uvm_macros.svh"

  import i2c_pkg::*;
  `include "demo_i2c_tb.sv"
  `include "demo_i2c_test_lib.sv"
  
  bit rst, clk;

  i2c_if vif(clk,rst);
  
  initial begin
    i2c_vif_config::set(null,"*.tb.i2c.*","vif", vif);
    run_test();
  end


  //Generate clk
  initial clk =0;
  always #5 clk = ~clk;


  initial begin
  $dumpfile("wave.vcd");
  $dumpvars;
  end

endmodule:demo_top
