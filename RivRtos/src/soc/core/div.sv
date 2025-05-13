module div_unit #(parameter XLEN = 32)(
    input  logic             clk,
    input  logic             reset_n,
    input  logic             start_i,
    input  logic             flush_i,
    input  logic             valid_i,
    input  logic [2:0]       funct3_i,
    input  logic [XLEN-1:0]  rs1_i,
    input  logic [XLEN-1:0]  rs2_i,
    input  logic [4:0]       rd_i,

    output logic             ready_o,
    output logic             busy_o,
    output logic [4:0]       rd_o,
    output logic [XLEN-1:0]  result_o
);

  //=======================
  // Internal State
  //=======================
  logic [2:0]       funct3_q;
  logic [4:0]       rd_q;
  logic [XLEN-1:0]  rs1_q, rs2_q;
  logic             op_in_progress;
  logic             is_signed, is_rem;
  logic             a_neg, b_neg, res_neg;
  logic [XLEN-1:0]  a_abs, b_abs;
  logic [XLEN-1:0]  quotient, remainder;
  logic             start_div;

  //=======================
  // Divider instantiation (unsigned)
  //=======================
  logic           div_start, div_busy, div_done, div_valid, div_dbz;
  logic [XLEN-1:0] div_quotient, div_remainder;
  //=======================
  // Latch Inputs (only when idle)
  //=======================
  logic start_ff;
  always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      funct3_q <= 3'b000;
      rd_q     <= 5'b0;
      rs1_q    <= 0;
      rs2_q    <= 0;
    end else if (~div_busy & ~start_ff & start_i) begin
      funct3_q <= funct3_i;
      rd_q     <= rd_i;
      rs1_q    <= rs1_i;
      rs2_q    <= rs2_i;
   end
  end

  always @(posedge clk, negedge reset_n) begin
    if(~reset_n) start_ff <= 0;
    else start_ff <= start_i & ~busy_o;
  end
  
  assign rd_o = rd_q;

  //=======================
  // Sign + ABS conversion
  //=======================
  assign is_signed = (funct3_q == 3'b100 || funct3_q == 3'b110); // DIV, REM
  assign is_rem    = (funct3_q == 3'b110 || funct3_q == 3'b111); // REM, REMU
  assign a_neg     = is_signed && rs1_q[XLEN-1];
  assign b_neg     = is_signed && rs2_q[XLEN-1];
  assign res_neg   = is_rem ? a_neg : (a_neg ^ b_neg);

  assign a_abs     = a_neg ? -rs1_q : rs1_q;
  assign b_abs     = b_neg ? -rs2_q : rs2_q;


  assign div_start = (!div_busy & start_ff);

  divu_int #(.WIDTH(XLEN)) u_divu (
    .clk    (clk),
    .rst    (~reset_n | flush_i), // logic on the reset? is fine? 
    .start  (div_start),
    .busy   (div_busy),
    .done   (div_done),
    .valid  (div_valid),
    .dbz    (div_dbz),
    .a      (a_abs),
    .b      (b_abs),
    .val    (div_quotient),
    .rem    (div_remainder)
  );

  //=======================
  // Sign Fix on Output
  //=======================
  assign quotient  = res_neg ? -div_quotient : div_quotient;
  assign remainder = a_neg   ? -div_remainder : div_remainder;

  assign result_o  = div_dbz ? (is_rem ? rs1_q : 32'hFFFFFFFF) :
                     (is_rem ? remainder : quotient);

  assign ready_o   = div_done;
  assign busy_o    = div_busy | div_start;

endmodule

module divu_int #(parameter WIDTH=5) ( // width of numbers in bits
    input wire logic clk,              // clock
    input wire logic rst,              // reset
    input wire logic start,            // start calculation
    output     logic busy,             // calculation in progress
    output     logic done,             // calculation is complete (high for one tick)
    output     logic valid,            // result is valid
    output     logic dbz,              // divide by zero
    input wire logic [WIDTH-1:0] a,    // dividend (numerator)
    input wire logic [WIDTH-1:0] b,    // divisor (denominator)
    output     logic [WIDTH-1:0] val,  // result value: quotient
    output     logic [WIDTH-1:0] rem   // result: remainder
    );

    logic [WIDTH-1:0] b1;             // copy of divisor
    logic [WIDTH-1:0] quo, quo_next;  // intermediate quotient
    logic [WIDTH:0] acc, acc_next;    // accumulator (1 bit wider)
    logic [$clog2(WIDTH)-1:0] i;      // iteration counter

    // division algorithm iteration
    always_comb begin
        if (acc >= {1'b0, b1}) begin
            acc_next = acc - b1;
            {acc_next, quo_next} = {acc_next[WIDTH-1:0], quo, 1'b1};
        end else begin
            {acc_next, quo_next} = {acc, quo} << 1;
        end
    end

    // calculation control
    always_ff @(posedge clk) begin
        
        if (rst) begin
            busy <= 0;
            done <= 0;
            valid <= 0;
            dbz <= 0;
            val <= 0;
            rem <= 0;
        end else if (start) begin
            valid <= 0;
            i <= 0;
            if (b == 0) begin  // catch divide by zero
                busy <= 0;
                done <= 1;
                dbz <= 1;
            end else begin
                done <= 0;
                busy <= 1;
                dbz <= 0;
                b1 <= b;
                {acc, quo} <= {{WIDTH{1'b0}}, a, 1'b0};  // initialize calculation
            end
        end else if (busy) begin
            if (i == WIDTH-1) begin  // we're done
                busy <= 0;
                done <= 1;
                valid <= 1;
                val <= quo_next;
                rem <= acc_next[WIDTH:1];  // undo final shift
            end else begin  // next iteration
                i <= i + 1;
                acc <= acc_next;
                quo <= quo_next;
            end
        end else begin 
                done <= 0;
        end
    end
endmodule
