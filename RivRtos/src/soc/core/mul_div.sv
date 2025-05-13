// =========================================
// MUL-DIV WRAPPER UNIT
// =========================================

module mul_div #(parameter XLEN = 32)(
    input  logic             clk,
    input  logic             rst,

    // Control + Decode
    input  logic             mul_div_i,        // high when instruction is M-extension
    input  logic [2:0]       funct3_i,
    input  logic             flush_i,
    input  logic             stall_i,

    // Operands
    input  logic [XLEN-1:0]  op1_i,
    input  logic [XLEN-1:0]  op2_i,
    input  logic [4:0]       rd_i,

    // Outputs - MULTIPLIER
    output logic [XLEN-1:0]  mul_res_o,
    output logic             mul_valid_o,
    output logic [4:0]       mul_rd_o,
    output logic [4:0]       mul_stage1_rd_o,
    output logic             mul_stage1_valid_o,

    // Outputs - DIVIDER
    output logic [XLEN-1:0]  div_res_o,
    output logic             div_valid_o,
    output logic [4:0]       div_rd_o,
    output logic             div_busy_o
);

  // -------- Internal Control Signals --------
  logic is_mul, is_div;
  logic start_div;
  logic valid_div;
  logic valid_mul;

  assign is_mul = mul_div_i && (funct3_i <= 3'b011); // MUL family
  assign is_div = mul_div_i && (funct3_i >= 3'b100); // DIV/REM family

  assign start_div = is_div && !stall_i;
  assign valid_div = is_div && !stall_i;
  assign valid_mul = is_mul && !stall_i;

  // ---------- Instantiate MULTIPLIER ----------
  mul_unit #(XLEN) u_mul (
    .clk(clk),
    .rst(rst),
    .start_i(valid_mul),
    .valid_i(valid_mul),
    .flush_i(flush_i),
    .stall_i(stall_i),
    .funct3_i(funct3_i),
    .rs1_i(op1_i),
    .rs2_i(op2_i),
    .rd_i(rd_i),
    .rd_stage1_valid_o(mul_stage1_valid_o),
    .rd_stage1_o(mul_stage1_rd_o),
    .rd_stage2_valid_o(mul_valid_o),
    .rd_stage2_o(mul_rd_o),
    .result_o(mul_res_o)
  );

  // ---------- Instantiate DIVIDER ----------
  div_unit #(XLEN) u_div (
    .clk(clk),
    .rst(rst),
    .start_i(start_div),
    .valid_i(valid_div),
    .flush_i(flush_i),
    .stall_i(stall_i),
    .funct3_i(funct3_i),
    .rs1_i(op1_i),
    .rs2_i(op2_i),
    .rd_i(rd_i),
    .ready_o(div_valid_o),
    .busy_o(div_busy_o),
    .rd_o(div_rd_o),
    .result_o(div_res_o)
  );

endmodule
