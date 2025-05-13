import riscv_types::*;

module crypto_unit (
    input logic [31:0] rs1,
    input logic [31:0] rs2,
    input logic [1:0] sha_sel,         // 2 LSB bits
    input logic reset,
    input alu_t crypto_ctrl,
    output logic [31:0] crypto_result
);

    logic enable;
    logic enable_enc;
    // just for debugginh
    logic debug_en;
    logic [31:0] xperm4_out, xperm8_out;
    logic [31:0] brev_out, rev_out;
    logic [31:0] clmul_out, clmulh_out;
    logic [31:0] zip_out, unzip_out;

    logic [31:0] aes32eMiddle_out, aes32eFinal_out;
    logic [31:0] aes32dMiddle_out, aes32dFinal_out;

    // SHA function outputs (declared as logic)
    logic [31:0] sha256sig0_out, sha256sig1_out;
    logic [31:0] sha256sum0_out, sha256sum1_out;
   
    always_comb begin
       if(is_aes32dsmi(crypto_ctrl) )begin
       enable = 1'b1;
       end
       else
       enable = 1'b0;
    end
    always_comb begin
           if(is_aes32esmi(crypto_ctrl) )begin
           enable_enc = 1'b1;
           end
           else
           enable_enc = 1'b0;
    end
    always_comb begin
               if(is_aes32esi(crypto_ctrl) )begin
               debug_en = 1'b1;
               end
               else
               debug_en = 1'b0;
        end
    // Instantiate the Bitmanip Modules
   
   /* clmul CLMUL ( .rs1(rs1), .rs2(rs2), .rd(clmul_out));
    clmulh CLMULH (.rs1(rs1), .rs2(rs2), .rd(clmulh_out));
    xperm4 XPERM4 (.rs1(rs1), .rs2(rs2), .rd(xperm4_out));
    xperm8 XPERM8 (.rs1(rs1), .rs2(rs2), .rd(xperm8_out));
    brev8 BREV (.rs(rs1), .rd(brev_out));
    rev8 REV (.rs(rs1), .rd(rev_out));
    zip ZIP (.rs(rs2), .rd(zip_out));
    unzip UNZIP (.rs(rs2), .rd(unzip_out));*/

    // Instantiate AES modules
    aes32esmi AES_ESM (
        .A(rs1), .B(rs2), .enable(enable_enc), .bs(crypto_ctrl[9:8]),
        .reset(reset), .Out(aes32eMiddle_out)
    );

    aes32esi AES_EF (
        .A(rs1), .B(rs2), .bs(crypto_ctrl[9:8]),
        .reset(reset), .Out(aes32eFinal_out)
    );

    aes32dsmi AES_DSM (
        .A(rs1), .B(rs2), .enable(enable), .bs(crypto_ctrl[9:8]),
        .reset(reset), .Out(aes32dMiddle_out)
    );

    aes32dsi AES_DF (
        .A(rs1), .B(rs2), .bs(crypto_ctrl[9:8]),
        .reset(reset), .Out(aes32dFinal_out)
    );

    // Instantiate SHA modules
    sha256sig0 SHA_SIG0 (
        .rs1(rs1),
        .rd(sha256sig0_out)
    );

    sha256sig1 SHA_SIG1 (
        .rs1(rs1),
        .rd(sha256sig1_out)
    );

    sha256sum0 SHA_SUM0 (
        .rs1(rs1),
        .rd(sha256sum0_out)
    );

    sha256sum1 SHA_SUM1 (
        .rs1(rs1),
        .rd(sha256sum1_out)
    );

    always_comb begin
        crypto_result = 32'b0;

        if (is_aes32esmi(crypto_ctrl)) begin
            crypto_result = aes32eMiddle_out;
        end
        else if (is_aes32esi(crypto_ctrl)) begin
            crypto_result = aes32eFinal_out;
        end
        else if (crypto_ctrl == 41) begin
            crypto_result = clmul_out;
        end
       
        else if (crypto_ctrl == 91) begin
            crypto_result = clmulh_out;
        end
       
        else if (crypto_ctrl == 162) begin
            crypto_result = xperm4_out;
        end
       
        else if (crypto_ctrl == 164) begin
            crypto_result = xperm8_out;
        end
       
        else if (crypto_ctrl == 33) begin
            crypto_result = zip_out;
        end
       
        else if (crypto_ctrl == 37) begin
            crypto_result = unzip_out;
        end
       
        else if (crypto_ctrl == 421) begin
            case (sha_sel[1:0])
                2'b11: crypto_result = brev_out;
                2'b00: crypto_result = rev_out;
            endcase
        end
        else if (is_aes32dsi(crypto_ctrl)) begin
            crypto_result = aes32dFinal_out;
        end
        else if (is_aes32dsmi(crypto_ctrl)) begin
            crypto_result = aes32dMiddle_out;
        end
        else if (is_sha256(crypto_ctrl)) begin  // SHA instruction selector
            case (sha_sel[1:0])
                2'b00: crypto_result = sha256sum0_out;
                2'b01: crypto_result = sha256sum1_out;
                2'b10: crypto_result = sha256sig0_out;
                2'b11: crypto_result = sha256sig1_out;
            endcase
        end
    end

endmodule