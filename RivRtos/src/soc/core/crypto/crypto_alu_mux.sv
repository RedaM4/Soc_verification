module crypto_alu_mux (
    input  [31:0] alu_result,     // Result from the normal ALU
    input  [31:0] crypto_result,  // Result from the crypto unit
    input  [4:0]  func5,          // Function 7 field from instruction
    input  [2:0]  func3,          // Function 3 field from instruction
    input  [6:0]  opcode,
    output [31:0] result          // Final result
);

    // Control signal to select between ALU and crypto unit
    reg select_crypto;
    
    // Combinational logic to determine if we're using a crypto instruction
    always @(*) begin
        // Default to using the ALU
        select_crypto = 1'b0;
        if (opcode == 7'b0110011) begin
        // Check for AES instructions based on func7 and func3 fields
        if ((func5 == 5'b10101) && (func3 == 3'b000) || // aes32dsi
            (func5 == 5'b10111) && (func3 == 3'b000) || // aes32dsmi
            (func5 == 5'b10001) && (func3 == 3'b000) || // aes32esi
            (func5 == 5'b10011) && (func3 == 3'b000) || // aes32esmi
            (func5 == 5'b00101)  && (func3 == 3'b001) || //clmul
            (func5 == 5'b00101)  && (func3 == 3'b011) || // clmulh
            (func5 == 5'b10100)  && (func3 == 3'b010) || //xperm4
            (func5 == 5'b10100)  && (func3 == 3'b100) || //xperm8
            (func5 == 5'b00100)  && (func3 == 3'b001) || //zip
            (func5 == 5'b00100)  && (func3 == 3'b101)  //unzip
            )  
        begin
            select_crypto = 1'b1;
        end 
        end 
        else if (opcode == 7'b0010011) begin 
            if ((func5 == 5'b01000 || func5 == 5'b10100) && (func3 == 3'b001 || func3 == 3'b101)) begin 
            select_crypto = 1'b1;
            end
        end
        else
        select_crypto = 1'b0;
    end
    
    // Multiplexer logic to select between ALU and crypto results
    assign result =  select_crypto ? crypto_result : alu_result ;
endmodule