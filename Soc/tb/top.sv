module top();
    
    import uvm_pkg::*;
`include "uvm_macros.svh"


// import uart_pkg::*;
import wb_pkg::*;
import clock_and_reset_pkg::*;
import spi_pkg::*;

import spi_module_pkg::*;

import soc_pkg::* ; 


//****************************8
//      NEEDS TOBE FIXED
//****************************8
`include "../sv/soc_mcsequencer.sv"
`include "../sv/soc_mcseqs_lib.sv"

`include "soc_tb.sv"
`include "soc_test_lib.sv"



hw_top dut();


initial begin
    //=============================================

//check path

    //=============================================
    // uart_vif_config::set(null,"*tb.uartenv.*","vif",dut.in_uart); 
    spi_vif_config::set(null,"*tb.spienv.*","vif",dut.in_spi1);

    wb_vif_config::set(null,"*tb.wbenv.*","vif",dut.in_wb);
    clock_and_reset_vif_config::set(null , "*tb.clk_rst_env.*" , "vif" , dut.clk_rst_if);
    
run_test("base_test") ; 

end



initial begin
$dumpfile("test.vcd");
$dumpvars();
end
//
 initial begin

    #70000000;
 $finish;end


endmodule