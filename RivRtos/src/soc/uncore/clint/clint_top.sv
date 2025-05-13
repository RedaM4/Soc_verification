module clint_top (
  input  wire        clk_i,    // 50 MHz system clock
  input  wire        rst_i,    // System reset, active high

  // Wishbone interface signals for the CLINT (not shown here)
  input  wire        cyc_i,
  input  wire        stb_i,
  input  wire [31:0] adr_i,
  input  wire        we_i,
  input  wire [3:0]  sel_i,
  input  wire [31:0] dat_i,
  output wire [31:0] dat_o,
  output wire        ack_o,
  input wire         halt, 
  // Timer interrupt output from CLINT to the Core
  output wire        timer_irq
);

  // // Generate the slow clock for mtime using the clock divider.
  // wire clk_mtime;
  
  // clock_div #(
  //   .EVEN_DIVISOR(1526)
  // ) clk_div_inst (
  //   .clk_i(clk_i),
  //   .rst_i(rst_i),
  //   .clk_o(clk_mtime)
  // );
  
  // assign clk_mtime = clk_i;

  // Instantiate the CLINT module and connect the divided clock.
  clint_wb clint_inst (
    .*
  );

endmodule
