module data_mem #(
    parameter DEPTH = 1024
)(
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
    
       
logic wb_acc;
logic mem_write, mem_read;

assign wb_acc = cyc_i & stb_i;
assign mem_write = wb_acc &  we_i;
assign mem_read  = wb_acc & ~we_i;

always_ff @(posedge clk_i) ack_o = wb_acc & ~ack_o; // delayed acknoledge


logic [$clog2(DEPTH)-1:0] word_addr;
assign word_addr = adr_i[$clog2(DEPTH)+1:2];

// inst memory here 
logic [31:0] dmem [0:DEPTH - 1];

always_ff @(posedge clk_i) begin 
    if(mem_write) begin 
        if(sel_i[0]) dmem[word_addr][7:0]   <= dat_i[7:0];
        if(sel_i[1]) dmem[word_addr][15:8]  <= dat_i[15:8];
        if(sel_i[2]) dmem[word_addr][23:16] <= dat_i[23:16];
        if(sel_i[3]) dmem[word_addr][31:24] <= dat_i[31:24];
    end
end

logic [31:0] data_o_reg, mem_rdata;

assign mem_rdata = dmem[word_addr];
n_bit_reg #(
    .n(32)
) data_o_reg_inst (
    .clk(clk_i),
    .reset_n (~rst_i     ),
    .data_i  (mem_rdata  ),
    .data_o  (data_o_reg ),
    .wen     (1'b1       )
);

assign dat_o = data_o_reg;


`ifdef VCS_SIM
    logic [31:0] dmem_0 ;
    logic [31:0] dmem_1 ;
    logic [31:0] dmem_2 ;
    logic [31:0] dmem_3 ;
    logic [31:0] dmem_4 ;
    logic [31:0] dmem_5 ;
    logic [31:0] dmem_6 ;
    logic [31:0] dmem_7 ;
    logic [31:0] dmem_8 ;
    logic [31:0] dmem_9 ;
    logic [31:0] dmem_10;
    logic [31:0] dmem_11;
    logic [31:0] dmem_12;
    logic [31:0] dmem_13;
    logic [31:0] dmem_14;

    assign dmem_0  = dmem[0 ];
    assign dmem_1  = dmem[1 ];
    assign dmem_2  = dmem[2 ];
    assign dmem_3  = dmem[3 ];
    assign dmem_4  = dmem[4 ];
    assign dmem_5  = dmem[5 ];
    assign dmem_6  = dmem[6 ];
    assign dmem_7  = dmem[7 ];
    assign dmem_8  = dmem[8 ];
    assign dmem_9  = dmem[9 ];
    assign dmem_10 = dmem[10];
    assign dmem_11 = dmem[11];
    assign dmem_12 = dmem[12];
    assign dmem_13 = dmem[13];
    assign dmem_14 = dmem[14];

`endif

endmodule
