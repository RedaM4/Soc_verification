module tb_mul_unit_4bit;
  logic clk = 0, reset_n = 1, stall_i = 0;
  logic [2:0] funct3;
  logic [3:0] rs1, rs2;
  logic [3:0] result;

  mul_unit #(.XLEN(4)) dut (
    .clk(clk), .reset_n(reset_n), .stall_i(stall_i),
    .funct3_i(funct3),
    .rs1_i(rs1), .rs2_i(rs2),
    .result_o(result)
  );

  always #5 clk = ~clk;

  initial begin
    $display("==== 4-bit MUL Unit Test Start ====");
    reset_n = 0; #12; reset_n = 1;

    // ==== MUL: -5 * 7 = 18 (0x12)
    rs1 = 4'b1011;  // -5 (signed)
    rs2 = 4'b0111;  // 7 (signed)
    funct3 = 3'b000;
    @(posedge clk); @(posedge clk);
    $display("MUL (-5 * 7): Result = 0x%h", result);  // Expect 0x12

    // ==== MULH: upper of -5 * -6 => 0x01 (if 8-bit result = 0x12)
    funct3 = 3'b001;
    @(posedge clk); @(posedge clk);
    $display("MULH: High Byte = 0x%h", result);  // Expect 0x01 or 0x00

    // ==== MULHSU: -3 (signed) * 10 (unsigned)
    rs2 = 4'b1010;  // 10
    funct3 = 3'b010;
    @(posedge clk); @(posedge clk);
    $display("MULHSU (-3 * 10): High = 0x%h", result);

    // ==== MULHU: 13 * 10 = 130 (0x82)
    rs1 = 4'd13;
    rs2 = 4'd10;
    funct3 = 3'b011;
    @(posedge clk); @(posedge clk);
    $display("MULHU (13 * 10): High = 0x%h", result);  // 130 = 0x82, High = 0x08

    $finish;
  end
endmodule
