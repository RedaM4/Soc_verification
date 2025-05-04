
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import uart_pkg::*;

    `include "uart_tb.sv"
    `include "uart_test_lib.sv"

module tb_top;

    logic clk;

    uart_if intf(.clk(clk));

    initial begin
        clk = 0;
        forever #10 clk = ~clk; 
    end

    initial begin
      uart_vif_config::set(null, "*", "vif", intf);
       run_test("base_test");  
    end
endmodule