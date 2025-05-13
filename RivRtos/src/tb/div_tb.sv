module tb_div_unit;

  logic clk = 0;
  logic reset_n = 0;
  always #5 clk = ~clk;

  logic start, flush, valid;
  logic [2:0] funct3;
  logic [31:0] rs1, rs2;
  logic [4:0] rd;

  logic ready, busy;
  logic [4:0] rd_out;
  logic [31:0] result;

  div_unit dut (
    .clk       (clk),
    .reset_n   (reset_n),
    .start_i   (start),
    .flush_i   (flush),
    .valid_i   (valid),
    .funct3_i  (funct3),
    .rs1_i     (rs1),
    .rs2_i     (rs2),
    .rd_i      (rd),
    .ready_o   (ready),
    .busy_o    (busy),
    .rd_o      (rd_out),
    .result_o  (result)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0);

    reset_n = 0; flush = 0; start = 0; valid = 0;
    #20 reset_n = 1;

    // Run tests
    run_div_test(-40, 8, 3'b100);  // DIV: -40 / 8 = -5
    run_div_test(40, 8, 3'b101);   // DIVU: 40 / 8 = 5
    run_div_test(-40, 6, 3'b110);  // REM: -40 % 6 = -4
    run_div_test(40, 6, 3'b111);   // REMU: 40 % 6 = 4
    run_div_test(123, 0, 3'b100);  // DIV by zero
    run_div_test(199, 197, 3'b111);   // REMU: 199 % 197 = 2


    run_div_test(32'hffffffff, 32'hfe98f000, 3'b111);   // x1:0xffffffff / x2:0xfe98f000
    run_div_test(0, -1, 3'b100);   // REMU: 199 % 197 = 2
    #100 $finish;
  end

  task run_div_test(input int a, b, input logic [2:0] f3);
    begin
      @(posedge clk);
      rs1 = a;
      rs2 = b;
      funct3 = f3;
      rd = 5'd10;
      valid = 1;
      start = 1;

      @(posedge clk);
      start = 0;
      valid = 0;

      wait (ready);
      #1;
      $display("Test: rs1=%0d, rs2=%0d, funct3=%b => result=%0d", a, b, f3, $signed(result));
    end
  endtask


  initial begin 
    #10000000;
        $display("TIMEOUT .... ");
        $finish;
  end

endmodule
