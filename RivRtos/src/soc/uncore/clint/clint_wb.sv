module clint_wb #(
  // Define offsets within the CLINT address space
  parameter MTIMECMP_LOW_ADDR  = 32'h20000c00,
  parameter MTIMECMP_HIGH_ADDR = 32'h20000c04,
  parameter MTIME_LOW_ADDR     = 32'h20000c08,
  parameter MTIME_HIGH_ADDR    = 32'h20000c0c
)(
  // Core (Wishbone) interface using core clock clk_i
  input  wire        clk_i,    // Core clock
  input  wire        rst_i,    // Synchronous reset (active high)
  input  wire        cyc_i,    // Cycle valid
  input  wire        stb_i,    // Strobe valid
  input  wire [31:0] adr_i,    // Address (in the CLINT region)
  input  wire        we_i,     // Write enable
  input  wire [3:0]  sel_i,    // Byte select
  input  wire [31:0] dat_i,    // Write data
  output reg  [31:0] dat_o,    // Read data
  output reg         ack_o,    // Wishbone acknowledge

  input wire         halt,
  // Timer interrupt output: asserted when mtime >= mtimecmp
  output wire        timer_irq
);

  // 64-bit mtime registers (split into two 32-bit registers)
  reg [31:0] mtime_lo;
  reg [31:0] mtime_hi;
  
  // 64-bit mtimecmp registers (split into two 32-bit registers)
  reg [31:0] mtimecmp_lo;
  reg [31:0] mtimecmp_hi;
  wire mtime_tick;

  // //-------------------------------------------------------------------------
  // // Synchronize clk_mtime into the core clock domain and detect a rising edge.
  // //-------------------------------------------------------------------------
  // reg clk_mtime_sync0, clk_mtime_sync1;
  // reg clk_mtime_prev;

  // // Two-stage synchronization of the slow clock, plus one register to hold
  // // the previous sample. All these registers are updated on the core clock.
  // always @(posedge clk_i or posedge rst_i) begin
  //   if (rst_i) begin
  //     clk_mtime_sync0 <= 1'b0;
  //     clk_mtime_sync1 <= 1'b0;
  //     clk_mtime_prev  <= 1'b0;
  //   end else begin
  //     clk_mtime_sync0 <= clk_mtime;
  //     clk_mtime_sync1 <= clk_mtime_sync0;
  //     clk_mtime_prev  <= clk_mtime_sync1;
  //   end
  // end

  // Always count (previously it was set to count at slow rate)
  assign mtime_tick = 1'b1;

  //-------------------------------------------------------------------------
  // Core clock domain: Update mtime and mtimecmp registers and handle Wishbone accesses.
  //-------------------------------------------------------------------------
  always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      mtime_lo    <= 32'd0;
      mtime_hi    <= 32'd0;
      mtimecmp_lo <= 32'd0;
      mtimecmp_hi <= 32'd0;
    end else begin
      // Process Wishbone write accesses.
      // When a write is enabled (cyc_i, stb_i, we_i) the corresponding register
      // is updated according to the address and byte select.
      if (cyc_i && stb_i && we_i) begin
        case (adr_i)
          MTIMECMP_LOW_ADDR: begin
            if (sel_i[0]) mtimecmp_lo[7:0]   <= dat_i[7:0];
            if (sel_i[1]) mtimecmp_lo[15:8]  <= dat_i[15:8];
            if (sel_i[2]) mtimecmp_lo[23:16] <= dat_i[23:16];
            if (sel_i[3]) mtimecmp_lo[31:24] <= dat_i[31:24];
          end
          MTIMECMP_HIGH_ADDR: begin
            if (sel_i[0]) mtimecmp_hi[7:0]   <= dat_i[7:0];
            if (sel_i[1]) mtimecmp_hi[15:8]  <= dat_i[15:8];
            if (sel_i[2]) mtimecmp_hi[23:16] <= dat_i[23:16];
            if (sel_i[3]) mtimecmp_hi[31:24] <= dat_i[31:24];
          end
          MTIME_LOW_ADDR: begin
            if (sel_i[0]) mtime_lo[7:0]   <= dat_i[7:0];
            if (sel_i[1]) mtime_lo[15:8]  <= dat_i[15:8];
            if (sel_i[2]) mtime_lo[23:16] <= dat_i[23:16];
            if (sel_i[3]) mtime_lo[31:24] <= dat_i[31:24];
          end
          MTIME_HIGH_ADDR: begin
            if (sel_i[0]) mtime_hi[7:0]   <= dat_i[7:0];
            if (sel_i[1]) mtime_hi[15:8]  <= dat_i[15:8];
            if (sel_i[2]) mtime_hi[23:16] <= dat_i[23:16];
            if (sel_i[3]) mtime_hi[31:24] <= dat_i[31:24];
          end
          default: ; // Do nothing for unmapped addresses.
        endcase
      end else begin 

      // Increment the mtime counter only on a mtime_tick,
      // and only if there is no simultaneous write to mtime registers.
      // (You may choose the priority here; in this design, writes override the tick.)
      if (mtime_tick & ~halt) begin
        if (mtime_lo == 32'hFFFFFFFF) begin
          mtime_lo <= 32'd0;
          mtime_hi <= mtime_hi + 1;
        end else begin
          mtime_lo <= mtime_lo + 1;
        end
      end
    end
    end
  end

  //-------------------------------------------------------------------------
  // Combinational read logic for the Wishbone interface.
  //-------------------------------------------------------------------------
  always @(*) begin
    case (adr_i)
      MTIMECMP_LOW_ADDR:  dat_o = mtimecmp_lo;
      MTIMECMP_HIGH_ADDR: dat_o = mtimecmp_hi;
      MTIME_LOW_ADDR:     dat_o = mtime_lo;
      MTIME_HIGH_ADDR:    dat_o = mtime_hi;
      default:            dat_o = 32'd0;
    endcase
  end

  // Generate Wishbone acknowledge signal.
  always @(*) begin
    ack_o = cyc_i && stb_i;
  end

  //-------------------------------------------------------------------------
  // Timer Interrupt Generation
  //-------------------------------------------------------------------------
  // Combine the 32-bit registers into a 64-bit value for comparison.
  wire [63:0] mtime_val    = {mtime_hi, mtime_lo};
  wire [63:0] mtimecmp_val = {mtimecmp_hi, mtimecmp_lo};

  // The timer interrupt is asserted when mtime is greater than or equal to mtimecmp.
  assign timer_irq = (mtime_val >= mtimecmp_val);

endmodule
