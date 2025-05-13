module sram_32k_wrapper (
  // 32bit WISHBONE bus slave interface
  input  wire        clk_i,         // clock
  input  wire        rst_i,         // reset (synchronous active high)
  input  wire        cyc_i,         // cycle
  input  wire        stb_i,         // strobe
  input  wire [31:0] adr_i,         // address
  input  wire        we_i,          // write enable
  input  wire [3:0]  sel_i,
  input  wire [31:0] dat_i,         // data input
  output reg  [31:0] dat_o,         // data output
  output reg         ack_o          // normal bus termination

);



logic  [31:0] Q;
logic  [12:0] ADR;
logic  [31:0] D;
logic  [31:0] WEM;
logic WE;
logic OE;
wire ME;
logic CLK;
logic  [3:0] RM;




assign D = dat_i;
assign ADR = adr_i[14:2];
assign dat_o = Q;
assign WEM[0] = sel_i[0];
assign WEM[1] = sel_i[0];
assign WEM[2] = sel_i[0];
assign WEM[3] = sel_i[0];
assign WEM[4] = sel_i[0];
assign WEM[5] = sel_i[0];
assign WEM[6] = sel_i[0];
assign WEM[7] = sel_i[0];
assign WEM[8] = sel_i[1];
assign WEM[9] = sel_i[1];
assign WEM[10] = sel_i[1];
assign WEM[11] = sel_i[1];
assign WEM[12] = sel_i[1];
assign WEM[13] = sel_i[1];
assign WEM[14] = sel_i[1];
assign WEM[15] = sel_i[1];
assign WEM[16] = sel_i[2];
assign WEM[17] = sel_i[2];
assign WEM[18] = sel_i[2];
assign WEM[19] = sel_i[2];
assign WEM[20] = sel_i[2];
assign WEM[21] = sel_i[2];
assign WEM[22] = sel_i[2];
assign WEM[23] = sel_i[2];
assign WEM[24] = sel_i[3];
assign WEM[25] = sel_i[3];
assign WEM[26] = sel_i[3];
assign WEM[27] = sel_i[3];
assign WEM[28] = sel_i[3];
assign WEM[29] = sel_i[3];
assign WEM[30] = sel_i[3];
assign WEM[31] = sel_i[3];
assign OE =  ~rst_i;
assign WE =  we_i & stb_i & cyc_i; 
assign ME  = ~rst_i; // stb_i & cyc_i
assign CLK = clk_i;
assign RM[3] = 1'b1; // recommended value by synopsys
assign RM[2] = 1'b0; // recommended value by synopsys
assign RM[1] = 1'b0; // recommended value by synopsys
assign RM[0] = 1'b0; // recommended value by synopsys

`ifdef PD_BUILD
  tsmc_32k_sq tsmc_32k_inst ( 
`else
  tsmc_32k tsmc_32k_inst ( 
`endif
    .Q, 
    .ADR, 
    .D, 
    .WEM, 
    .WE, 
    .OE, 
    .ME, 
    .CLK, 
    .RM);


always_ff @(posedge clk_i) ack_o <= stb_i & cyc_i & ~ack_o;

endmodule : sram_32k_wrapper




module sram_8k_wrapper (
  // 32bit WISHBONE bus slave interface
  input  wire        clk_i,         // clock
  input  wire        rst_i,         // reset (synchronous active high)
  input  wire        cyc_i,         // cycle
  input  wire        stb_i,         // strobe
  input  wire [31:0] adr_i,         // address
  input  wire        we_i,          // write enable
  input  wire [3:0]  sel_i,
  input  wire [31:0] dat_i,         // data input
  output reg  [31:0] dat_o,         // data output
  output reg         ack_o          // normal bus termination

);



logic  [31:0] Q;
logic  [10:0] ADR;
logic  [31:0] D;
logic  [31:0] WEM;
logic WE;
logic OE;
logic ME;
logic CLK;
logic  [3:0] RM;




assign D = dat_i;
assign ADR = adr_i[12:2];
assign dat_o = Q;
assign WEM[0] = sel_i[0];
assign WEM[1] = sel_i[0];
assign WEM[2] = sel_i[0];
assign WEM[3] = sel_i[0];
assign WEM[4] = sel_i[0];
assign WEM[5] = sel_i[0];
assign WEM[6] = sel_i[0];
assign WEM[7] = sel_i[0];
assign WEM[8] = sel_i[1];
assign WEM[9] = sel_i[1];
assign WEM[10] = sel_i[1];
assign WEM[11] = sel_i[1];
assign WEM[12] = sel_i[1];
assign WEM[13] = sel_i[1];
assign WEM[14] = sel_i[1];
assign WEM[15] = sel_i[1];
assign WEM[16] = sel_i[2];
assign WEM[17] = sel_i[2];
assign WEM[18] = sel_i[2];
assign WEM[19] = sel_i[2];
assign WEM[20] = sel_i[2];
assign WEM[21] = sel_i[2];
assign WEM[22] = sel_i[2];
assign WEM[23] = sel_i[2];
assign WEM[24] = sel_i[3];
assign WEM[25] = sel_i[3];
assign WEM[26] = sel_i[3];
assign WEM[27] = sel_i[3];
assign WEM[28] = sel_i[3];
assign WEM[29] = sel_i[3];
assign WEM[30] = sel_i[3];
assign WEM[31] = sel_i[3];
assign OE = ~we_i & stb_i & cyc_i;
assign WE =  we_i & stb_i & cyc_i; 
assign ME  = ~rst_i; // stb_i & cyc_i
assign CLK = clk_i;
assign RM[3] = 1'b1; // recommended value by synopsys
assign RM[2] = 1'b1; // recommended value by synopsys
assign RM[1] = 1'b0; // recommended value by synopsys
assign RM[0] = 1'b1; // recommended value by synopsys


tsmc_8k tsmc_8k_inst ( 
    .Q, 
    .ADR, 
    .D, 
    .WEM, 
    .WE, 
    .OE, 
    .ME, 
    .CLK, 
    .RM);


always_ff @(posedge clk_i) ack_o <= stb_i & cyc_i & ~ack_o;

endmodule : sram_8k_wrapper

