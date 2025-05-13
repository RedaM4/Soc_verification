import riscv_types::*;

`ifndef VIVADO_BUILD 
    `ifdef crypto
        `include "soc/core/crypto/crypto_bitmanip_lib.sv"
        `include "soc/core/crypto/crypto_alu_mux.sv"
        `include "soc/core/crypto/crypto_unit.sv"
    `endif
`endif
module alu (
    input alu_t alu_ctrl,
    input logic [31:0] op1,
    input logic [31:0] op2,
    output logic [31:0] alu_result, 
    output logic zero
);

    always_comb begin 
        case(alu_ctrl)
			ADD: alu_result = op1 + op2;
            ROL: alu_result = (op1 << op2[4:0]) | (op1 >> (32 - op2[4:0]));
            ROR: alu_result = (op1 >> op2[4:0]) | (op1 << (32 - op2[4:0]));
            SUB: alu_result = op1 - op2;
      		SLT: alu_result = $signed(op1) < $signed(op2) ? 1'b1 : 1'b0;
	        SLL: alu_result = op1 << op2[4:0];
            ANDN: alu_result = op1 & op2;
            ORN: alu_result = op1 | op2;
            XNORN: alu_result = op1 ^ op2;
            PACK: alu_result = {op2[15:0], op1[15:0]};
            PACKH: alu_result = {16'b0, op2[7:0], op1[7:0]};
            SRL: alu_result = op1 >> op2[4:0];
            SRA: alu_result = $signed(op1) >>> op2[4:0];
            XOR: alu_result = op1 ^ op2;
            AND: alu_result = op1 & op2;
            OR: alu_result  = op1 | op2;
            SLTU: alu_result = op1 < op2;
            default: alu_result = 32'd0;
        endcase
    end
    
    
    assign zero = (alu_result == 0);
endmodule