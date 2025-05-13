module exception_encoder (
    input logic ecall,
    input logic inst_addr_malign,
    input logic load_addr_malign, 
    input logic illegal_inst, 
    input logic store_amo_addr_malign, 

    output logic exception_o, 
    output logic [4:0] exception_code_o
);

    // local parameters, Eception coder sa per RISC-V spec 
    localparam logic [4:0] EXC_INST_ADDR_MISALIGNED      = 5'd0;
    localparam logic [4:0] EXC_ILLEGAL_INSTRUCTION       = 5'd2;
    localparam logic [4:0] EXC_LOAD_ADDR_MISALIGNED      = 5'd4;
    localparam logic [4:0] EXC_STORE_AMO_ADDR_MISALIGNED = 5'd6;
    localparam logic [4:0] EXC_ECALL_MMODE               = 5'd11;


    // always block for priority logic 
    always_comb begin 
        if(inst_addr_malign)           exception_code_o = EXC_INST_ADDR_MISALIGNED;
        else if(illegal_inst)          exception_code_o = EXC_ILLEGAL_INSTRUCTION;
        else if(load_addr_malign)      exception_code_o = EXC_LOAD_ADDR_MISALIGNED;
        else if(store_amo_addr_malign) exception_code_o = EXC_STORE_AMO_ADDR_MISALIGNED;
        else                           exception_code_o = EXC_ECALL_MMODE;
    end

    assign exception_o =  ecall 
                        | store_amo_addr_malign 
                        | load_addr_malign
                        | illegal_inst
                        | inst_addr_malign;

endmodule