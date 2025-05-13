// typedef enum logic [6:0] {
//     R_TYPE = 7'b0110011, 
//     I_TYPE = 7'b0010011, 
//     B_TYPE = 7'b1100011, 
//     JAL    = 7'b1101111, 
//     JALR   = 7'b1100111, 
//     LOAD   = 7'b0000011, 
//     STORE  = 7'b0100011, 
//     LUI    = 7'b0110111, 
//     AUIPC = 7'b0010111
// } inst_type;

// module decode_control (
//     input logic [6:0] opcode,
//     output logic reg_write, 
//     output logic mem_write, 
//     output logic mem_to_reg, 
//     output logic branch, 
//     output logic alu_src, 
//     output logic jump, 
//     output logic [1:0] alu_op,
//     output logic lui, 
//     output logic auipc,
//     output logic jal,
//     output logic r_type
// );


    
//     logic jump_or_upper_immediate;
//     assign jump_or_upper_immediate = opcode[2];

//     logic invalid_inst;
//     assign  invalid_inst = ~|opcode[1:0];


//     logic jalr;

//     logic br_or_jump;
//     assign br_or_jump = opcode[6];

//     logic [3:0] decoder_o;
//     n_bit_dec_with_en #(
//             .n(2)
//     ) type_decoder (
//             .en(~jump_or_upper_immediate & ~br_or_jump),
//             .in(opcode[5:4]),
//             .out(decoder_o)
//         );

//     logic i_type, load, store, b_type, u_type;

//     assign b_type = br_or_jump & ~jump;
//     assign i_type =  decoder_o[1];
//     assign r_type =  decoder_o[3];
//     assign load   =  decoder_o[0];
//     assign store =  decoder_o[2];
//     assign u_type = jump_or_upper_immediate & opcode[4];


//     assign jump     = jump_or_upper_immediate & ~opcode[4]; 
//     assign jal   = jump_or_upper_immediate & ~opcode[4] & opcode[3]; 
//     assign lui   = u_type & opcode[5]; 
//     assign auipc = u_type & ~opcode[5];

    
//     assign mem_write = store;
//     assign branch    = b_type;
//     assign alu_src   = ~(r_type | b_type);
//     assign alu_op = opcode[5:4] & {2{~(store | jump_or_upper_immediate)}};
//     assign mem_to_reg = load & ~invalid_inst;

//     assign reg_write = ~ (b_type | store);

// endmodule : decode_control


module decode_control (
    input  logic [6:0] opcode,
    output logic       reg_write, 
    output logic       mem_write, 
    output logic       mem_to_reg, 
    output logic       branch, 
    output logic       alu_src, 
    output logic       jump, 
    output logic [1:0] alu_op,
    output logic       lui, 
    output logic       auipc,
    output logic       jal,
    output logic       r_type,
    output logic       sys_inst,
    output logic       is_atomic,
    output logic       illegal_inst  
);

always_comb begin
    // Set defaults: if not explicitly enabled, signals are low.
    reg_write    = 1'b0;
    mem_write    = 1'b0;
    mem_to_reg   = 1'b0;
    branch       = 1'b0;
    alu_src      = 1'b0;
    jump         = 1'b0;
    alu_op       = 2'b00;
    lui          = 1'b0;
    auipc        = 1'b0;
    jal          = 1'b0;
    r_type       = 1'b0;
    sys_inst     = 1'b0;
    is_atomic    = 1'b0;
    illegal_inst = 1'b0;
    
    case (opcode)
      7'b0110011: begin // R-type
        reg_write = 1'b1;
        alu_src   = 1'b0;
        alu_op    = 2'b11;
        r_type    = 1'b1;
      end

      7'b0010011: begin // I-type ALU instructions
        reg_write = 1'b1;
        alu_src   = 1'b1;
        alu_op    = 2'b01;
      end

      7'b0000011: begin // LOAD
        reg_write  = 1'b1;
        mem_to_reg = 1'b1;
        alu_src    = 1'b1;
        alu_op     = 2'b00;
      end

      7'b0100011: begin // STORE
        mem_write = 1'b1;
        alu_src   = 1'b1;
        alu_op    = 2'b00;
      end

      7'b1100011: begin // Branch (B-type)
        branch = 1'b1;
        alu_src = 1'b0;
        alu_op  = 2'b10;
      end

      7'b1101111: begin // JAL
        jump      = 1'b1;
        reg_write = 1'b1;  // Write return address
        jal       = 1'b1;
      end

      7'b1100111: begin // JALR
        jump      = 1'b1;
        reg_write = 1'b1;  // Write return address
      end

      7'b0110111: begin // LUI
        reg_write = 1'b1;
        lui       = 1'b1;
        alu_src   = 1'b1;
      end

      7'b0010111: begin // AUIPC
        reg_write = 1'b1;
        auipc     = 1'b1;
        alu_src   = 1'b1;
      end

      7'b1110011: begin // CSR instructions
        sys_inst  = 1'b1;
        reg_write = 1'b1;
      end

      7'b0101111: begin // atomic instructions
        is_atomic = 1'b1;
        reg_write = 1'b1;
      end
      7'b0000000: begin // flushed instruction 
      end
      default: begin
        illegal_inst = 1'b1;
      end
    endcase
  end

endmodule
