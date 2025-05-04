
module tb_top;

import uvm_pkg::*;
`include "uvm_macros.svh"
import wb_pkg::*;

`include "wb_demo_tb.sv"  
`include "wb_test_lib.sv"

bit clock;
bit reset;

    wb_if vif(clock,reset);
    //clock_and_reset_if clk_n_rst_if();

    // initial begin
    //     clk_n_rst_if.clock = 0;
    //     forever #5 clk_n_rst_if.clock = ~clk_n_rst_if.clock;
    // end

        initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    initial begin
        reset = 1;
        #20 reset = 0;
    end

    initial begin
        wb_vif_config::set(null, "*.env.master_agent*", "vif", vif);
        wb_vif_config::set(null, "*.env.slave_agent*", "vif", vif);
       // clock_and_reset_vif_config::set(null, "*.clk_n_rst*", "vif", clk_n_rst_if);

        run_test("wb_test");
    end

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_top);
    end
endmodule
