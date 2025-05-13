

// Decoders here
module n_bit_dec #(
    parameter n = 2
)(
    input logic [n-1:0] in,
    output logic [(1<<n) - 1:0] out
);
    assign out = 1 << in;

endmodule : n_bit_dec

module n_bit_dec_with_en #(
    parameter n = 2
)(
    input logic [n-1:0] in,
    input logic en,
    output logic [(1<<n) - 1:0] out
);
    assign out = en << in;

endmodule : n_bit_dec_with_en

// Multiplexers here 
module mux4x1 #(
    parameter n = 4
)(
    input logic [n-1:0] in0, in1, in2, in3,
    input logic [1:0] sel,
    output logic [n-1:0]out
);

    always_comb begin 
        case(sel) 
            0: out = in0;
            1: out = in1;
            2: out = in2;
            3: out = in3;
        endcase
    end

endmodule

module mux2x1 #(
    parameter n = 4
)(
    input logic [n-1:0] in0, in1,
    input logic sel,
    output logic [n-1:0] out
);

     always_comb begin 
        case(sel) 
            0: out = in0;
            1: out = in1;
        endcase
    end   

endmodule

module mux3x1 #(
    parameter n = 32
)(
    input wire  [ 1 :0] sel,
    input wire  [n-1:0] in0,
    input wire  [n-1:0] in1,
    input wire  [n-1:0] in2,
    output wire [n-1:0] out
);

    // selection signals 
    wire sel0, sel1, sel2;

    // selection signals logic
    assign sel0 = ~sel[1] & ~sel[0]; 
    assign sel1 = ~sel[1] &  sel[0]; 
    assign sel2 =  sel[1] & ~sel[0];  

    // selecting signals using selection signals
    assign out =  {n{sel0}} & in0
                | {n{sel1}} & in1
                | {n{sel2}} & in2;
                
endmodule

module one_hot_mux4x1 #(
    parameter n = 1
) (
    input logic [3:0] sel, 
    input logic [n-1:0] in0, in1, in2, in3,
    output logic [n-1:0] out
);

    assign out =   in0 & {n{sel[0]}}
                 | in1 & {n{sel[1]}}
                 | in2 & {n{sel[2]}}
                 | in3 & {n{sel[3]}}; 

endmodule : one_hot_mux4x1


module one_hot_mux2x1 #(
    parameter n = 1
) (
    input logic [1:0] sel, 
    input logic [n-1:0] in0, in1,
    output logic [n-1:0] out
);

    assign out =   in0 & {n{sel[0]}}
                 | in1 & {n{sel[1]}}; 
                 
endmodule : one_hot_mux2x1


module one_hot_mux3x1 #(
    parameter n = 1
) (
    input logic [2:0] sel, 
    input logic [n-1:0] in0, in1, in2,
    output logic [n-1:0] out
);

    assign out =   in0 & {n{sel[0]}}
                 | in1 & {n{sel[1]}}
                 | in2 & {n{sel[2]}}; 

endmodule : one_hot_mux3x1


module n_bit_reg_wo_en #(
    parameter n = 8
)(
    input logic clk, 
    input logic  [n-1:0] data_i, 
    output logic [n-1:0] data_o
);

    logic [n-1:0] n_bit_reg;
    always_ff @(posedge clk) begin 
        begin 
            n_bit_reg <= data_i;
        end
    end

    assign data_o = n_bit_reg;
endmodule : n_bit_reg_wo_en



module n_bit_reg #(
    parameter n = 8,
    parameter RESET_VALUE = 0
)(
    input logic clk, 
    input logic reset_n,

    input logic wen, 
    input logic  [n-1:0] data_i, 
    output logic [n-1:0] data_o
);

    logic [n-1:0] n_bit_reg;
    always_ff @(posedge clk, negedge reset_n) begin 
        if(~reset_n)begin 
            n_bit_reg <= RESET_VALUE;
        end else if (wen) begin 
            n_bit_reg <= data_i;
        end
    end

    assign data_o = n_bit_reg;
endmodule : n_bit_reg


module n_bit_reg_wclr #(
    parameter n = 8,
    parameter RESET_VALUE = 0,
    parameter CLR_VALUE = 0
)(
    input logic clk, 
    input logic reset_n,

    input logic wen, 
    input logic  [n-1:0] data_i, 
    output logic [n-1:0] data_o,
    input logic clear
);

    logic [n-1:0] n_bit_reg;
    always_ff @(posedge clk, negedge reset_n) begin 
        if(~reset_n)begin 
            n_bit_reg <= RESET_VALUE;
        end else if (clear) begin
            n_bit_reg <= CLR_VALUE; 
        end else if (wen) begin 
            n_bit_reg <= data_i;
        end
    end

    assign data_o = n_bit_reg;
    
endmodule : n_bit_reg_wclr



package riscv_types;
        
    // ALU operation types
     typedef enum logic [9:0]  { 
         ADD, SLL, SLT, SLTU, XOR, SRL, OR, AND, 
         SUB = 256, PACK = 68, PACKH = 71, CLMUL = 41, 
         CLMULH = 43, XPERM4 = 162, XPERM8 = 164,
         XNORN = 260, SRA = 261, ORN = 262, ANDN = 263,
         ROL = 385, ROR = 389, BREV = 421,
         //  encryption and decryption added 
         AES32ESMI = 152,
         AES32ESI  = 136,
         AES32DSI  = 168,
         AES32DSMI = 184,
         // SHA instruction added 
         SHA256 = 65
     } alu_t;
    
    function automatic logic is_aes32esmi(alu_t op);
         return (op == AES32ESMI || op == 664 || op == 408 || op == 920);
     endfunction
     // Function to check if crypto_ctrl corresponds to AES32ESI (136, 392, 648, 904)
     function automatic logic is_aes32esi(alu_t op);
         return (op == AES32ESI || op == 392 || op == 648 || op == 904);
     endfunction
     //Function to check if crypto unit corresponds to AES32DSI (168, 424, 680, 936)
     function automatic logic is_aes32dsi(alu_t op);
              return (op == AES32DSI || op == 424 || op == 680 || op == 936);
      endfunction
      //Function to check if crypto unit corresponds to AES32DSI (168, 424, 680, 936)
      function automatic logic is_aes32dsmi(alu_t op);
              return (op == AES32DSMI || op == 440 || op == 696 || op == 952);
      endfunction
      // function for  sha
      function automatic logic is_sha256(alu_t op);
                    return (op == SHA256);
       endfunction
      // EXTRA LOGIC  
     // Function to determine cryptographic enable signal (crypt_en)
     function automatic logic get_crypt_en(alu_t op);
         case (op)
             136, 392, 648, 904: get_crypt_en = 1'b0;  // not set for final round 
             152, 408, 664, 920: get_crypt_en = 1'b1;  // set for middle round 
             default:  get_crypt_en = 1'b0; // Non-crypto operations
         endcase
     endfunction

    // Store operation types
    typedef enum logic [1:0] { 
        STORE_BYTE, STORE_HALFWORD, STORE_WORD 
    } store_t;

    // IF1/IF2 Register Structure
    typedef struct packed {
        logic [31:0] current_pc;
        logic [31:0] pc_plus_4;
    } if1_if2_reg_t;

    // IF/ID Register Structure
    typedef struct packed {
        logic [31:0] current_pc;
        logic [31:0] pc_plus_4;
        logic [31:0] inst;
        logic        inst_valid;
    } if2_id_reg_t;

    // ID/EX Register Structure
    typedef struct packed {
        // Data signals 
        logic [31:0] current_pc; 
        logic [31:0] pc_plus_4;
        logic [4:0]  rs1;
        logic [4:0]  rs2;
        logic [4:0]  rd; 
        logic [2:0]  fun3;
        logic        fun7_5;
        logic [6:0]  fun7;
        logic [4:0]  fun5;
        logic [4:0]  sha_sel;
        logic [6:0]  opcode;
        logic [31:0] reg_rdata1;
        logic [31:0] reg_rdata2;
        logic [31:0] imm;
        logic [11:0] csr_addr;
        // Control signals
        logic        reg_write;
        logic        mem_write;
        logic        mem_to_reg;
        logic        branch;
        logic        alu_src;
        logic        jump;
        logic        lui;
        logic        auipc;
        logic        jal;
        logic [1:0]  alu_op;
        logic        csr_inst;
        logic        csr_en;
        logic        trap_ret;
        logic        is_atomic;
        logic        is_mul;
        logic        is_div;
        logic        ecall;
        logic        illegal_inst;
        logic        inst_valid;
        logic        ebreak_inst;
        `ifdef tracer 
            logic [31:0] inst;
        `endif
    } id_exe_reg_t;

    // EX/MEM Register Structure
    typedef struct packed {
        // Data signals 
        logic [31:0] pc_plus_4;
        logic [31:0] pc_jump;      
        logic [4:0]  rs2;
        logic [4:0]  rd; 
        logic [2:0]  fun3;
        logic [31:0] rdata2_frw;
        logic [31:0] imm;
        logic [31:0] crypto_alu_result;
        logic [31:0] reg_rdata1;
        logic [11:0] csr_addr;
        logic [31:0] current_pc;

        // Control signals
        logic        reg_write;
        logic        mem_write;
        logic        mem_to_reg;
        logic        branch;
        logic        jump;
        logic        lui;
        logic        zero;
        logic        csr_inst;
        logic        csr_en;
        logic        trap_ret;
        logic        is_atomic;
        logic        is_mul;
        logic        ecall;
        logic        illegal_inst;
        logic        inst_valid;
        logic        ebreak_inst;
        `ifdef tracer 
            logic [31:0] inst;
            logic [4:0]  rs1;
        `endif
    } exe_mem_reg_t;

    // MEM/WB Register Structure
    typedef struct packed {
        // Data signals 
        logic [4:0]  rd; 
        logic [31:0] result;
        logic [31:0] atomic_unit_wdata;
        logic [31:0] mul_result;
        // Control signals
        logic        reg_write;
        logic        atomic_unit_valid_rd;
        logic        pc_sel;
        logic        is_mul;
        logic        inst_valid;
        `ifdef tracer 
            logic [31:0] inst;
            logic [4:0]  rs1;
            logic [4:0]  rs2;
            logic [31:0] reg_rdata1;
            logic [31:0] reg_rdata2;
            logic [31:0] current_pc;
            logic [31:0] mem_rdata; 
            logic [31:0] mem_wdata; 
            logic [31:0] mem_addr;
        `endif
    } mem_wb_reg_t;

endpackage



module clock_div #(
  parameter EVEN_DIVISOR = 1526  
)(
  input  logic clk_i,  
  input  logic rst_i,   
  output logic clk_o    
);

  // Calculate half of the divisor
  localparam HALF_DIV = EVEN_DIVISOR / 2;
  
  // Use a counter with sufficient bit width. $clog2(HALF_DIV) gives the number of bits needed.
  reg [$clog2(HALF_DIV)-1:0] counter;
  reg clk_div; 

  always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
      counter <= 0;
      clk_div <= 1'b0;
    end else begin
      if (counter == (HALF_DIV - 1)) begin
        counter <= 0;
        clk_div <= ~clk_div;  // Toggle the output clock
      end else begin
        counter <= counter + 1;
      end
    end
  end

  // Drive the output with the divided clock signal.
  assign clk_o = clk_div;

endmodule
