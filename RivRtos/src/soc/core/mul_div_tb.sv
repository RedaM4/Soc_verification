// ==========================
// Testbench for mul_unit and div_unit
// ==========================

`timescale 1ns/1ps

module mul_div_tb;

  logic clk = 0;
  logic rst = 1;
  always #5 clk = ~clk; // 100 MHz clock

  // Inputs
  logic start;
  logic flush;
  logic stall;
  logic valid;
  logic [2:0] funct3;
  logic [31:0] rs1;
  logic [31:0] rs2;
  logic [4:0] rd;

  // Outputs from MUL
  logic rd_stage1_valid;
  logic [4:0] rd_stage1;
  logic rd_stage2_valid;
  logic [4:0] rd_stage2;
  logic [31:0] mul_result;

  // Outputs from DIV
  logic ready_div;
  logic busy_div;
  logic [4:0] rd_div;
  logic [31:0] div_result;

  // Instantiate Multiplier
  mul_unit mul_inst (
    .clk(clk), .rst(rst), .start_i(start), .valid_i(valid), .flush_i(flush), .stall_i(stall),
    .funct3_i(funct3), .rs1_i(rs1), .rs2_i(rs2), .rd_i(rd),
    .rd_stage1_valid_o(rd_stage1_valid), .rd_stage1_o(rd_stage1),
    .rd_stage2_valid_o(rd_stage2_valid), .rd_stage2_o(rd_stage2),
    .result_o(mul_result)
  );

  // Instantiate Divider
  div_unit div_inst (
    .clk(clk), .rst(rst), .start_i(start), .valid_i(valid), .flush_i(flush), .stall_i(stall),
    .funct3_i(funct3), .rs1_i(rs1), .rs2_i(rs2), .rd_i(rd),
    .ready_o(ready_div), .busy_o(busy_div), .rd_o(rd_div), .result_o(div_result)
  );

  initial begin
    $display("[TB] Starting MUL/DIV testbench");
    #10 rst = 0;
    flush = 0;
    stall = 0;

    // DIV Test: rs1 = 100, rs2 = 4 => result = 52
    start = 1; valid = 1;
    funct3 = 3'b100; // DIV
    rs1 = 32'd100;
    rs2 = 32'd4;
    rd = 5'd2;
    #10 start = 0; valid = 0;

    // Wait for DIV0omplete
    wait (ready_div);
    $display("[TB] DIV result = %0d, RD = %0d", div_result, rd_div);

    #10;
    // DIV Test 2: rs1 = 32, rs2 = 4 => result = 8
    start = 1; valid = 1;
    funct3 = 3'b100; // DIV
    rs1 = 32'd32;
    rs2 = 32'd4;
    rd = 5'd3;
    #10 start = 0; valid = 0;

    // Wait for DIV to complete
    wait (ready_div);
    $display("[TB] DIV result = %0d, RD = %0d", div_result, rd_div);

 #10;
    // REM Test: rs1 = 20, rs2 = 6 => result = 2
    start = 1; valid = 1;
    funct3 = 3'b110; // REM
    rs1 = 32'd119;
    rs2 = 32'd6;
    rd = 5'd4;
    #10 start = 0; valid = 0;

    wait (ready_div);
    $display("[TB] REM result = %0d, RD = %0d", div_result, rd_div);

    #20;
    $display("[TB] Testbench finished");
    $finish;
  end

  initial begin 
	$dumpfile("wavefrom.vcd");
$dumpvars(0);	
end

endmodule
