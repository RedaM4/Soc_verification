module mul_unit #(parameter XLEN = 32)(
    input  logic             clk,
    input  logic             reset_n,
    input  logic             stall_i,
    input  logic [2:0]       funct3_i,    // 000: MUL, 001: MULH, 010: MULHSU, 011: MULHU
    input  logic [XLEN-1:0]  rs1_i,
    input  logic [XLEN-1:0]  rs2_i,
    output logic [XLEN-1:0]  result_o
);

  localparam HALF = XLEN / 2;

  logic [XLEN-1:0] a_lo, b_lo;
  logic [XLEN-1:0] a_hi, b_hi;

  logic signed [2*XLEN-1:0] p0, p1, p2, p3;

  // Stage 1: partial multiplications
  always_comb begin
    a_lo = rs1_i[HALF-1:0];
    a_hi = {{HALF{rs1_i[XLEN-1]}},rs1_i[XLEN-1:HALF]};
    b_lo = rs2_i[HALF-1:0];
    b_hi = {{HALF{rs2_i[XLEN-1]}},rs2_i[XLEN-1:HALF]};


    unique case (funct3_i)
      3'b000, 3'b001: begin // signed × signed
        p0 = $signed(a_lo) * $signed(b_lo);
        p1 = $signed(a_lo) * $signed(b_hi);
        p2 = $signed(a_hi) * $signed(b_lo);
        p3 = $signed(a_hi) * $signed(b_hi);
      end
      3'b010: begin // signed × unsigned
        b_hi = rs2_i[XLEN-1:HALF];
        p0 = $signed(a_lo) * $signed(b_lo);
        p1 = $signed(a_lo) * $signed(b_hi);
        p2 = $signed(a_hi) * $signed(b_lo);
        p3 = $signed(a_hi) * $signed(b_hi);
      end
      3'b011: begin // unsigned × unsigned
        a_hi = rs1_i[XLEN-1:HALF];
        b_hi = rs2_i[XLEN-1:HALF];
        p0 = $signed(a_lo) * $signed(b_lo);
        p1 = $signed(a_lo) * $signed(b_hi);
        p2 = $signed(a_hi) * $signed(b_lo);
        p3 = $signed(a_hi) * $signed(b_hi);
      end
      default: begin
        p0 = 0; p1 = 0; p2 = 0; p3 = 0;
      end
    endcase

    // $display("a_lo = %d, b_lo = %d", a_lo, b_lo);
    // $display("a_hi = %d, b_hi = %d", $signed(a_hi), b_hi);

  end

  // Stage 2: register partials and add
  logic signed [2:0] funct3_ff;
  logic signed [2*XLEN-1:0] p0_ff, p1_ff, p2_ff, p3_ff, final_product;

  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      funct3_ff <= 3'b000;
      p0_ff <= 0; p1_ff <= 0; p2_ff <= 0; p3_ff <= 0;
    end else if (!stall_i) begin
      funct3_ff <= funct3_i;
      p0_ff <= p0;
      p1_ff <= p1 << HALF;
      p2_ff <= p2 << HALF;
      p3_ff <= p3 << (2*HALF);
    end
  end

  assign final_product = p0_ff + p1_ff + p2_ff + p3_ff;
  // always @(*)
  // begin 
  //   $display("p0 = %d, p1 = %d, p2 = %d, p3 = %d, Product is %d", p0,p1,p2,p3,final_product);
  // end
  
  assign result_o = (funct3_ff == 3'b000) ? final_product[XLEN-1:0] :
                    (funct3_ff == 3'b001) ? final_product[2*XLEN-1:XLEN] :
                    (funct3_ff == 3'b010) ? final_product[2*XLEN-1:XLEN] :
                    (funct3_ff == 3'b011) ? final_product[2*XLEN-1:XLEN] :
                    '0;

endmodule
