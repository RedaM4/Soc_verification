module clmul (
    input logic [31:0] rs1,
    input logic [31:0] rs2, 
    output logic [31:0] rd 
);
    integer i;
    logic  [31:0] out;
    always_comb begin
        out = '0; // Initialize output to zero

        for (i = 0; i < 32; i++) begin
            if (rs2[i]) begin
                out ^= (rs1 << i); // XOR with left-shifted rs1
            end
        end
    end
        assign rd = out;
endmodule

module clmulh(
       input logic [31:0] rs1,
       input logic [31:0] rs2,
       output logic [31:0] rd
    );
   integer i;
   logic  [31:0] out;
        always @(*) begin
            out = 32'b0; 
            for (i = 0; i < 32; i = i + 1) begin
                if (rs2[i] == 1'b1) begin
                    out = out ^ (rs1 >> (32-i)); 
                end
            end
            rd = out;
        end  
endmodule

module zip(input [31:0] rs, output reg [31:0] rd);
	integer i;
	integer j;
	always@(*) begin
		for(i = 0; i < 16; i = i + 1) begin
			rd[2*i] = rs[i];
		end
		i = 0;
		for(j = 16; j < 32; j = j + 1) begin
			rd[2*i + 1] = rs[j];
			i = i + 1;
		end
	end

endmodule

module unzip(input [31:0] rs, output reg [31:0] rd);
	integer i;
	integer j;
	
	always@(*) begin
		for( i =0; i < 16; i = i + 1) begin
			rd[i] = rs[2*i];
			rd[i + 16] = rs[2*i + 1];
		end
	end
endmodule

module brev8(input [31:0] rs, output reg [31:0] rd);
	integer i;
	always @(*) begin
		for(i = 0; i < 31; i = i + 8) begin
			rd[i] = rs[7 + i];
			rd[i+1] = rs[7 + i - 1];
			rd[i+2] = rs[7 + i - 2];
			rd[i+3] = rs[7 + i - 3];
			rd[i+4] = rs[7 + i - 4];
			rd[i+5] = rs[7 + i - 5];
			rd[i+6] = rs[7 + i - 6];
			rd[i+7] = rs[7 + i - 7];
		end
	end
endmodule


module rev8 (
    input  wire [31:0] rs,
    output wire [31:0] rd
);
    assign rd = {rs[7:0], rs[15:8], rs[23:16], rs[31:24]};
endmodule






module xperm4 (
    input wire [31:0] rs1,
    input wire [31:0] rs2,
    output wire [31:0] rd
);

    reg [31:0] result;
    integer i;

    always @(*) begin
        result = 32'b0;
        for (i = 0; i < 8; i = i + 1) begin // Iterate over nibbles (8 in a 32-bit register)
            case (rs2[i*4 +: 4])
                4'h0: result[i*4 +: 4] = rs1[31:28];
                4'h1: result[i*4 +: 4] = rs1[27:24];
                4'h2: result[i*4 +: 4] = rs1[23:20];
                4'h3: result[i*4 +: 4] = rs1[19:16];
                4'h4: result[i*4 +: 4] = rs1[15:12];
                4'h5: result[i*4 +: 4] = rs1[11:8];
                4'h6: result[i*4 +: 4] = rs1[7:4];
                4'h7: result[i*4 +: 4] = rs1[3:0];
                default: result[i*4 +: 4] = 4'b0; // Invalid index
            endcase
        end
    end

    assign rd = result;

endmodule


module xperm8 (
    input  wire [31:0] rs1,
    input  wire [31:0] rs2,
    output wire [31:0] rd
);

    reg [31:0] result;
    integer i;

    always @(*) begin
        result = 32'b0;
        for (i = 0; i < 4; i = i + 1) begin
            case (rs2[i*8 +: 8])
                8'h00: result[i*8 +: 8] = rs1[31:24];
                8'h01: result[i*8 +: 8] = rs1[23:16];
                8'h02: result[i*8 +: 8] = rs1[15:8];
                8'h03: result[i*8 +: 8] = rs1[7:0];
                default: result[i*8 +: 8] = 8'b0;
            endcase
        end
    end

    assign rd = result;

endmodule







////////////////////////////////    AES  ////////////////////////////////

module aes32esmi
(
	input [31:0] A,
	input [31:0] B,
	input [1:0] bs,
	input reset,
	input enable,
	output reg [31:0] Out
);
	wire[7:0] so1,so2,so3,so4;
	wire [31:0] key;
	wire [31:0] mixed_out, shift_rows,shifted_rows;
	wire [31:0] shamt;
	wire [31:0] shifted;
	assign key = {B[7:0], B[15:8], B[23:16], B[31:24]};
	s_box S1(.si(A[7:0]),.so(so1));
	s_box S2(.si(A[15:8]),.so(so2));
	s_box S3(.si(A[23:16]),.so(so3));
	s_box S4(.si(A[31:24]),.so(so4));
	
	rol RO(.rs1({so4,so3,so2,so1}),. rs2({27'b0, bs, 3'b0}),.rd(shifted));
	mix_column MX(.A(shifted),.reset(reset),.bs(bs),.enable(enable),.cypher(mixed_out));
	
	//xoring the key with the output of the mixed columns
	always @(*) begin
	   Out = B[31:0] ^ mixed_out[31:0];
	   
	end
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Muhammad Sufiyan Sadiq 
// 
// Create Date: 08/07/2024 10:53:24 AM
// Design Name: 
// Module Name: aes32esi
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//	A <---- Cypher Text
//	B <---- Key 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 	You can make the aes32esmi and aes32esi one module if you just add a mux
//	to the aes32esmi to bypass the mix column step, we will need to say how to 
//	implement the final thing into the RISCV core.
//////////////////////////////////////////////////////////////////////////////////


module aes32esi
(
	input [31:0] A,
	input [31:0] B,
	input [1:0] bs,
	input reset,
	//output [31:0] shifted,
	output reg [31:0] Out
);
	wire[7:0] so1,so2,so3,so4;
	wire [31:0] mixed_out, shift_rows,shifted_rows;
	wire [31:0] shamt;
	wire [31:0] shifted;
	s_box S1(.si(A[7:0]),.so(so1));
	s_box S2(.si(A[15:8]),.so(so2));
	s_box S3(.si(A[23:16]),.so(so3));
	s_box S4(.si(A[31:24]),.so(so4));
	
	rol RO(.rs1({so4,so3,so2,so1}),. rs2({27'b0, bs, 3'b0}),.rd(shifted));
	//xoring the key with the output of the mixed columns
	always @(*) begin
	   Out = B[31:0] ^ shifted[31:0];
	end
endmodule

module s_box(input [7:0] si, output reg [7:0]so);
	always @(*) begin
		case(si) 
			8'h00: so=8'h63;
			8'h01: so=8'h7c;
			8'h02: so=8'h77;
			8'h03: so=8'h7b;
			8'h04: so=8'hf2;
			8'h05: so=8'h6b;
			8'h06: so=8'h6f;
			8'h07: so=8'hc5;
			8'h08: so=8'h30;
			8'h09: so=8'h01;
			8'h0a: so=8'h67;
			8'h0b: so=8'h2b;
			8'h0c: so=8'hfe;
			8'h0d: so=8'hd7;
			8'h0e: so=8'hab;
			8'h0f: so=8'h76;
			8'h10: so=8'hca;
			8'h11: so=8'h82;
			8'h12: so=8'hc9;
			8'h13: so=8'h7d;
			8'h14: so=8'hfa;
			8'h15: so=8'h59;
			8'h16: so=8'h47;
			8'h17: so=8'hf0;
			8'h18: so=8'had;
			8'h19: so=8'hd4;
			8'h1a: so=8'ha2;
			8'h1b: so=8'haf;
			8'h1c: so=8'h9c;
			8'h1d: so=8'ha4;
			8'h1e: so=8'h72;
			8'h1f: so=8'hc0;
			8'h20: so=8'hb7;
			8'h21: so=8'hfd;
			8'h22: so=8'h93;
			8'h23: so=8'h26;
			8'h24: so=8'h36;
			8'h25: so=8'h3f;
			8'h26: so=8'hf7;
			8'h27: so=8'hcc;
			8'h28: so=8'h34;
			8'h29: so=8'ha5;
			8'h2a: so=8'he5;
			8'h2b: so=8'hf1;
			8'h2c: so=8'h71;
			8'h2d: so=8'hd8;
			8'h2e: so=8'h31;
			8'h2f: so=8'h15;
			8'h30: so=8'h04;
			8'h31: so=8'hc7;
			8'h32: so=8'h23;
			8'h33: so=8'hc3;
			8'h34: so=8'h18;
			8'h35: so=8'h96;
			8'h36: so=8'h05;
			8'h37: so=8'h9a;
			8'h38: so=8'h07;
			8'h39: so=8'h12;
			8'h3a: so=8'h80;
			8'h3b: so=8'he2;
			8'h3c: so=8'heb;
			8'h3d: so=8'h27;
			8'h3e: so=8'hb2;
			8'h3f: so=8'h75;
			8'h40: so=8'h09;
			8'h41: so=8'h83;
			8'h42: so=8'h2c;
			8'h43: so=8'h1a;
			8'h44: so=8'h1b;
			8'h45: so=8'h6e;
			8'h46: so=8'h5a;
			8'h47: so=8'ha0;
			8'h48: so=8'h52;
			8'h49: so=8'h3b;
			8'h4a: so=8'hd6;
			8'h4b: so=8'hb3;
			8'h4c: so=8'h29;
			8'h4d: so=8'he3;
			8'h4e: so=8'h2f;
			8'h4f: so=8'h84;
			8'h50: so=8'h53;
			8'h51: so=8'hd1;
			8'h52: so=8'h00;
			8'h53: so=8'hed;
			8'h54: so=8'h20;
			8'h55: so=8'hfc;
			8'h56: so=8'hb1;
			8'h57: so=8'h5b;
			8'h58: so=8'h6a;
			8'h59: so=8'hcb;
			8'h5a: so=8'hbe;
			8'h5b: so=8'h39;
			8'h5c: so=8'h4a;
			8'h5d: so=8'h4c;
			8'h5e: so=8'h58;
			8'h5f: so=8'hcf;
			8'h60: so=8'hd0;
			8'h61: so=8'hef;
			8'h62: so=8'haa;
			8'h63: so=8'hfb;
			8'h64: so=8'h43;
			8'h65: so=8'h4d;
			8'h66: so=8'h33;
			8'h67: so=8'h85;
			8'h68: so=8'h45;
			8'h69: so=8'hf9;
			8'h6a: so=8'h02;
			8'h6b: so=8'h7f;
			8'h6c: so=8'h50;
			8'h6d: so=8'h3c;
			8'h6e: so=8'h9f;
			8'h6f: so=8'ha8;
			8'h70: so=8'h51;
			8'h71: so=8'ha3;
			8'h72: so=8'h40;
			8'h73: so=8'h8f;
			8'h74: so=8'h92;
			8'h75: so=8'h9d;
			8'h76: so=8'h38;
			8'h77: so=8'hf5;
			8'h78: so=8'hbc;
			8'h79: so=8'hb6;
			8'h7a: so=8'hda;
			8'h7b: so=8'h21;
			8'h7c: so=8'h10;
			8'h7d: so=8'hff;
			8'h7e: so=8'hf3;
			8'h7f: so=8'hd2;
			8'h80: so=8'hcd;
			8'h81: so=8'h0c;
			8'h82: so=8'h13;
			8'h83: so=8'hec;
			8'h84: so=8'h5f;
			8'h85: so=8'h97;
			8'h86: so=8'h44;
			8'h87: so=8'h17;
			8'h88: so=8'hc4;
			8'h89: so=8'ha7;
			8'h8a: so=8'h7e;
			8'h8b: so=8'h3d;
			8'h8c: so=8'h64;
			8'h8d: so=8'h5d;
			8'h8e: so=8'h19;
			8'h8f: so=8'h73;
			8'h90: so=8'h60;
			8'h91: so=8'h81;
			8'h92: so=8'h4f;
			8'h93: so=8'hdc;
			8'h94: so=8'h22;
			8'h95: so=8'h2a;
			8'h96: so=8'h90;
			8'h97: so=8'h88;
			8'h98: so=8'h46;
			8'h99: so=8'hee;
			8'h9a: so=8'hb8;
			8'h9b: so=8'h14;
			8'h9c: so=8'hde;
			8'h9d: so=8'h5e;
			8'h9e: so=8'h0b;
			8'h9f: so=8'hdb;
			8'ha0: so=8'he0;
			8'ha1: so=8'h32;
			8'ha2: so=8'h3a;
			8'ha3: so=8'h0a;
			8'ha4: so=8'h49;
			8'ha5: so=8'h06;
			8'ha6: so=8'h24;
			8'ha7: so=8'h5c;
			8'ha8: so=8'hc2;
			8'ha9: so=8'hd3;
			8'haa: so=8'hac;
			8'hab: so=8'h62;
			8'hac: so=8'h91;
			8'had: so=8'h95;
			8'hae: so=8'he4;
			8'haf: so=8'h79;
			8'hb0: so=8'he7;
			8'hb1: so=8'hc8;
			8'hb2: so=8'h37;
			8'hb3: so=8'h6d;
			8'hb4: so=8'h8d;
			8'hb5: so=8'hd5;
			8'hb6: so=8'h4e;
			8'hb7: so=8'ha9;
			8'hb8: so=8'h6c;
			8'hb9: so=8'h56;
			8'hba: so=8'hf4;
			8'hbb: so=8'hea;
			8'hbc: so=8'h65;
			8'hbd: so=8'h7a;
			8'hbe: so=8'hae;
			8'hbf: so=8'h08;
			8'hc0: so=8'hba;
			8'hc1: so=8'h78;
			8'hc2: so=8'h25;
			8'hc3: so=8'h2e;
			8'hc4: so=8'h1c;
			8'hc5: so=8'ha6;
			8'hc6: so=8'hb4;
			8'hc7: so=8'hc6;
			8'hc8: so=8'he8;
			8'hc9: so=8'hdd;
			8'hca: so=8'h74;
			8'hcb: so=8'h1f;
			8'hcc: so=8'h4b;
			8'hcd: so=8'hbd;
			8'hce: so=8'h8b;
			8'hcf: so=8'h8a;
			8'hd0: so=8'h70;
			8'hd1: so=8'h3e;
			8'hd2: so=8'hb5;
			8'hd3: so=8'h66;
			8'hd4: so=8'h48;
			8'hd5: so=8'h03;
			8'hd6: so=8'hf6;
			8'hd7: so=8'h0e;
			8'hd8: so=8'h61;
			8'hd9: so=8'h35;
			8'hda: so=8'h57;
			8'hdb: so=8'hb9;
			8'hdc: so=8'h86;
			8'hdd: so=8'hc1;
			8'hde: so=8'h1d;
			8'hdf: so=8'h9e;
			8'he0: so=8'he1;
			8'he1: so=8'hf8;
			8'he2: so=8'h98;
			8'he3: so=8'h11;
			8'he4: so=8'h69;
			8'he5: so=8'hd9;
			8'he6: so=8'h8e;
			8'he7: so=8'h94;
			8'he8: so=8'h9b;
			8'he9: so=8'h1e;
			8'hea: so=8'h87;
			8'heb: so=8'he9;
			8'hec: so=8'hce;
			8'hed: so=8'h55;
			8'hee: so=8'h28;
			8'hef: so=8'hdf;
			8'hf0: so=8'h8c;
			8'hf1: so=8'ha1;
			8'hf2: so=8'h89;
			8'hf3: so=8'h0d;
			8'hf4: so=8'hbf;
			8'hf5: so=8'he6;
			8'hf6: so=8'h42;
			8'hf7: so=8'h68;
			8'hf8: so=8'h41;
			8'hf9: so=8'h99;
			8'hfa: so=8'h2d;
			8'hfb: so=8'h0f;
			8'hfc: so=8'hb0;
			8'hfd: so=8'h54;
			8'hfe: so=8'hbb;
			8'hff: so=8'h16;
		endcase
	
	
	end	
endmodule



module rol(
    input [31:0] rs1,  // 1st source register 
    input [31:0] rs2,  // 2nd source register 
    output [31:0] rd    // destination register 
);
    wire [4:0] shamt;  // shamt is a 5 bit value extracted from rs2
    assign shamt = rs2[4:0];
    assign rd = (rs1 << shamt) | (rs1 >> (32 - shamt)); // destination reg has rs1 left-shifted by shamt bits 
endmodule

module mix_column
(
	input [31:0] A,
	input reset,
	input [1:0] bs,
	input enable,
	output [31:0] cypher,
	output  [7:0] out1, 
	output  [7:0] out2,
	output  [7:0] out3,
	output [7:0] out4
);

reg [7:0] temp1,temp2,temp3,temp4;
reg [7:0] shift_matrix [3:0];
reg previous_state;
reg [7:0] swap;
integer i;

//need to add another array which checks which row is being operated on
//one possible solution could be that whenever the command is triggered it
//begins counting and if it overflows from meaning we need to change the
//constant reg fil
//need to add another case statement with similiar logic to this one and
//we can thus control a shift register with values.
always @(*) begin
	//this case is to check which rows of the mixed matrix to multiply
	//first
	if(!reset) begin
		previous_state = 0;
	end
	else begin
		case(shift_matrix[0])
		8'b01: 
		begin	
		//has 2 additional patterns that need to be accounted
		//for [1 2 3 1] and [1 1 2 3]
		if(shift_matrix[1] == 2) begin
			if(bs == 2'b00) begin
				temp1 = (A[7:0]);
				temp2 = (A[15:8]);
				temp3 = (A[23:16]);
				temp4 = (A[31:24]);
				previous_state = 0;
			end
			else if(bs == 2'b01) begin
				temp1 = (A[7:0] << 1) ^ (8'h1b & {8{A[7]}});
				temp2 = (A[15:8] <<1) ^ (8'h1b & {8{A[15]}});
				temp3 = (A[23:16] << 1) ^ (8'h1b & {8{A[23]}});
				temp4 = (A[31:24] << 1) ^ (8'h1b & {8{A[31]}});
				previous_state = 0;
			end
			else if(bs == 2'b10) begin
				temp1 = (A[7:0] << 1) ^ A[7:0] ^ (8'h1b & {8{A[7]}});
				temp2 = (A[15:8] << 1) ^ A[15:8] ^ (8'h1b & {8{A[15]}});
				temp3 = (A[23:16] << 1) ^ A[23:16] ^ (8'h1b & {8{A[23]}});
				temp4 = (A[31:24] << 1) ^ A[31:24] ^ (8'h1b & {8{A[31]}});
				previous_state = 0;
			end
			else begin	
				temp1 = A[7:0];
				temp2 = A[15:8];
				temp3 = A[23:16];
				temp4 = A[31:24];
				previous_state = 1;
			end	
		end
		else begin
			if(bs == 2'b00) begin
				temp1 = (A[7:0]);
				temp2 = (A[15:8]);
				temp3 = (A[23:16]);
				temp4 = (A[31:24]);
				previous_state = 0;
			end
			else if(bs == 2'b01) begin
				temp1 = (A[7:0]);
				temp2 = (A[15:8]);
				temp3 = (A[23:16]);
				temp4 = (A[31:24]);
				previous_state = 0;
			end
			else if(bs == 2'b10) begin
				temp1 = (A[7:0] << 1) ^ (8'h1b & {8{A[7]}});
				temp2 = (A[15:8] << 1) ^ (8'h1b & {8{A[15]}});
				temp3 = (A[23:16] << 1) ^ (8'h1b & {8{A[23]}});
				temp4 = (A[31:24] << 1) ^ (8'h1b & {8{A[31]}});
				previous_state = 0;
			end
			else begin
				temp1 = (A[7:0] << 1) ^ A[7:0] ^ (8'h1b & {8{A[7]}});
				temp2 = (A[15:8] <<  1) ^ A[15:8] ^ (8'h1b & {8{A[15]}});
				temp3 = (A[23:16] << 1) ^ A[23:16] ^ (8'h1b & {8{A[23]}});
				temp4 = (A[31:24] << 1) ^ A[31:24] ^ (8'h1b & {8{A[31]}});
				previous_state = 1;
			end	
		end
	end
	8'b10:
	begin
		//only one case which will have this
		if(bs == 2'b00) begin
			temp1 = (A[7:0] << 1) ^ (8'h1b & {8{A[7]}});
			temp2 = (A[15:8] << 1) ^ (8'h1b & {8{A[15]}});
			temp3 = (A[23:16] << 1) ^ (8'h1b & {8{A[23]}});
			temp4 = (A[31:24] << 1) ^ (8'h1b & {8{A[31]}});
			previous_state = 0;
		end
		else if(bs == 2'b01) begin
			temp1 = (A[7:0] << 1) ^ A[7:0] ^ (8'h1b & {8{A[7]}});
			temp2 = (A[15:8] << 1) ^ A[15:8] ^ (8'h1b & {8{A[15]}});
			temp3 = (A[23:16] << 1) ^ A[23:16] ^ (8'h1b & {8{A[23]}});
			temp4 = (A[31:24] << 1) ^ A[31:24] ^ (8'h1b & {8{A[31]}}); 	
			previous_state = 0;
		end
		else if(bs == 2'b10) begin
			temp1 = A[7:0];
			temp2 = A[15:8];
			temp3 = A[23:16];
			temp4 = A[31:24];
			previous_state = 0;
		end
		else begin	
			temp1 = A[7:0];
			temp2 = A[15:8];
			temp3 = A[23:16];
			temp4 = A[31:24];
			previous_state = 1;
		end
	end
	8'b11:
	begin
		//only has one case
		if(bs == 2'b00) begin
			temp1 = (A[7:0] << 1) ^ A[7:0] ^ (8'h1b & {8{A[7]}});
			temp2 = (A[15:8] << 1) ^ A[15:8] ^ (8'h1b & {8{A[15]}});
			temp3 = (A[23:16] << 1) ^ A[23:16] ^ (8'h1b & {8{A[23]}});
			temp4 = (A[31:24] << 1) ^ A[31:24] ^ (8'h1b & {8{A[31]}});
			previous_state = 0;
		end
		else if(bs == 2'b01) begin
			temp1 = (A[7:0]);
			temp2 = (A[15:8]);
			temp3 = (A[23:16]);
			temp4 = (A[31:24]);
			previous_state = 0;
		end
		else if(bs == 2'b10) begin
			temp1 = A[7:0];
			temp2 = A[15:8];
			temp3 = A[23:16];
			temp4 = A[31:24];
			previous_state = 0;
		end
		else begin		
			temp1 = (A[7:0] << 1) ^ (8'h1b & {8{A[7]}});
			temp2 = (A[15:8] << 1)  ^ (8'h1b & {8{A[15]}});
			temp3 = (A[23:16] << 1) ^ (8'h1b & {8{A[23]}});
			temp4 = (A[31:24] << 1) ^ (8'h1b & {8{A[31]}});
			previous_state = 1;
		end
	end			
	endcase
	end
	
  end
  
	always @(negedge previous_state , negedge reset) begin
		if(!reset) begin
			shift_matrix[0] = 2;
			shift_matrix[1] = 3;
			shift_matrix[2] = 1;
			shift_matrix[3] = 1;
		end
		else if(enable) begin
				swap = shift_matrix[3];
				shift_matrix[3] = shift_matrix[2];
				shift_matrix[2] = shift_matrix[1];
				shift_matrix[1] = shift_matrix[0];
				shift_matrix[0] = swap;
			end
			else begin	
			shift_matrix[0] = 2;
            shift_matrix[1] = 3;
            shift_matrix[2] = 1;
            shift_matrix[3] = 1;				
		end
	end

   assign cypher = {temp4, temp3, temp2, temp1};
	assign out1 = shift_matrix[0];
	assign out2 = shift_matrix[1];
	assign out3 = shift_matrix[2];
	assign out4 = shift_matrix[3];
endmodule




module aes32dsmi(
	input [31:0] A,
	input [31:0] B,
	input [1:0] bs,
	input reset,
	input enable,
	output [31:0] shifted,
	output [31:0] mout,
	output reg [31:0] Out
);
	wire[7:0] so1,so2,so3,so4;
	wire [31:0] shift_rows,shifted_rows;
	wire [31:0] shamt;
	inverseSbox S1(.selector(A[7:0]),.sbout(so1));
	inverseSbox S2(.selector(A[15:8]),.sbout(so2));
	inverseSbox S3(.selector(A[23:16]),.sbout(so3));
	inverseSbox S4(.selector(A[31:24]),.sbout(so4));
	ror RO(.rs1({so4,so3,so2,so1}),. rs2({27'b0, bs, 3'b0}),.rd(shifted));
	inv_mix_column IMX(.A(shifted),.bs(bs),.reset(reset), .enable(enable), .cypher(mout));
	always @(*) begin
	   Out = B[31:0] ^ mout[31:0];
	end
endmodule

module aes32dsi
(
	input [31:0] A,
	input [31:0] B,
	input [1:0] bs,
	input reset,
	output reg [31:0] Out
);

	wire[7:0] so1,so2,so3,so4;
	wire [31:0] mixed_out, shift_rows,shifted_rows;
	wire [31:0] shamt;
	wire [31:0] shifted;
	
	inverseSbox S1(.selector(A[7:0]),.sbout(so1));
	inverseSbox S2(.selector(A[15:8]),.sbout(so2));
	inverseSbox S3(.selector(A[23:16]),.sbout(so3));
	inverseSbox S4(.selector(A[31:24]),.sbout(so4));
	
	ror RO(.rs1({so4,so3,so2,so1}),. rs2({27'b0, bs, 3'b0}),.rd(shifted));
	always @(*) begin
	   Out = B[31:0] ^ shifted[31:0];
	end
	
endmodule


module inverseSbox(selector,sbout);
input  [7:0] selector; 
output reg [7:0] sbout;

 always@(*)
 begin  
    case(selector)
				8'h00:sbout =8'h52;
				8'h01:sbout =8'h09;
				8'h02:sbout =8'h6a;
				8'h03:sbout =8'hd5;
				8'h04:sbout =8'h30;
				8'h05:sbout =8'h36;
				8'h06:sbout =8'ha5;
				8'h07:sbout =8'h38;
				8'h08:sbout =8'hbf;
				8'h09:sbout =8'h40;
				8'h0a:sbout =8'ha3;
				8'h0b:sbout =8'h9e;
				8'h0c:sbout =8'h81;
				8'h0d:sbout =8'hf3;
				8'h0e:sbout =8'hd7;
				8'h0f:sbout =8'hfb;
				8'h10:sbout =8'h7c;
				8'h11:sbout =8'he3;
				8'h12:sbout =8'h39;
				8'h13:sbout =8'h82;
				8'h14:sbout =8'h9b;
				8'h15:sbout =8'h2f;
				8'h16:sbout =8'hff;
				8'h17:sbout =8'h87;
				8'h18:sbout =8'h34;
				8'h19:sbout =8'h8e;
				8'h1a:sbout =8'h43;
				8'h1b:sbout =8'h44;
				8'h1c:sbout =8'hc4;
				8'h1d:sbout =8'hde;
				8'h1e:sbout =8'he9;
				8'h1f:sbout =8'hcb;
				8'h20:sbout =8'h54;
				8'h21:sbout =8'h7b;
				8'h22:sbout =8'h94;
				8'h23:sbout =8'h32;
				8'h24:sbout =8'ha6;
				8'h25:sbout =8'hc2;
				8'h26:sbout =8'h23;
				8'h27:sbout =8'h3d;
				8'h28:sbout =8'hee;
				8'h29:sbout =8'h4c;
				8'h2a:sbout =8'h95;
				8'h2b:sbout =8'h0b;
				8'h2c:sbout =8'h42;
				8'h2d:sbout =8'hfa;
				8'h2e:sbout =8'hc3;
				8'h2f:sbout =8'h4e;
				8'h30:sbout =8'h08;
				8'h31:sbout =8'h2e;
				8'h32:sbout =8'ha1;
				8'h33:sbout =8'h66;
				8'h34:sbout =8'h28;
				8'h35:sbout =8'hd9;
				8'h36:sbout =8'h24;
				8'h37:sbout =8'hb2;
				8'h38:sbout =8'h76;
				8'h39:sbout =8'h5b;
				8'h3a:sbout =8'ha2;
				8'h3b:sbout =8'h49;
				8'h3c:sbout =8'h6d;
				8'h3d:sbout =8'h8b;
				8'h3e:sbout =8'hd1;
				8'h3f:sbout =8'h25;
				8'h40:sbout =8'h72;
				8'h41:sbout =8'hf8;
				8'h42:sbout =8'hf6;
				8'h43:sbout =8'h64;
				8'h44:sbout =8'h86;
				8'h45:sbout =8'h68;
				8'h46:sbout =8'h98;
				8'h47:sbout =8'h16;
				8'h48:sbout =8'hd4;
				8'h49:sbout =8'ha4;
				8'h4a:sbout =8'h5c;
				8'h4b:sbout =8'hcc;
				8'h4c:sbout =8'h5d;
				8'h4d:sbout =8'h65;
				8'h4e:sbout =8'hb6;
				8'h4f:sbout =8'h92;
				8'h50:sbout =8'h6c;
				8'h51:sbout =8'h70;
				8'h52:sbout =8'h48;
				8'h53:sbout =8'h50;
				8'h54:sbout =8'hfd;
				8'h55:sbout =8'hed;
				8'h56:sbout =8'hb9;
				8'h57:sbout =8'hda;
				8'h58:sbout =8'h5e;
				8'h59:sbout =8'h15;
				8'h5a:sbout =8'h46;
				8'h5b:sbout =8'h57;
				8'h5c:sbout =8'ha7;
				8'h5d:sbout =8'h8d;
				8'h5e:sbout =8'h9d;
				8'h5f:sbout =8'h84;
				8'h60:sbout =8'h90;
				8'h61:sbout =8'hd8;
				8'h62:sbout =8'hab;
				8'h63:sbout =8'h00;
				8'h64:sbout =8'h8c;
				8'h65:sbout =8'hbc;
				8'h66:sbout =8'hd3;
				8'h67:sbout =8'h0a;
				8'h68:sbout =8'hf7;
				8'h69:sbout =8'he4;
				8'h6a:sbout =8'h58;
				8'h6b:sbout =8'h05;
				8'h6c:sbout =8'hb8;
				8'h6d:sbout =8'hb3;
				8'h6e:sbout =8'h45;
				8'h6f:sbout =8'h06;
				8'h70:sbout =8'hd0;
				8'h71:sbout =8'h2c;
				8'h72:sbout =8'h1e;
				8'h73:sbout =8'h8f;
				8'h74:sbout =8'hca;
				8'h75:sbout =8'h3f;
				8'h76:sbout =8'h0f;
				8'h77:sbout =8'h02;
				8'h78:sbout =8'hc1;
				8'h79:sbout =8'haf;
				8'h7a:sbout =8'hbd;
				8'h7b:sbout =8'h03;
				8'h7c:sbout =8'h01;
				8'h7d:sbout =8'h13;
				8'h7e:sbout =8'h8a;
				8'h7f:sbout =8'h6b;
				8'h80:sbout =8'h3a;
				8'h81:sbout =8'h91;
				8'h82:sbout =8'h11;
				8'h83:sbout =8'h41;
				8'h84:sbout =8'h4f;
				8'h85:sbout =8'h67;
				8'h86:sbout =8'hdc;
				8'h87:sbout =8'hea;
				8'h88:sbout =8'h97;
				8'h89:sbout =8'hf2;
				8'h8a:sbout =8'hcf;
				8'h8b:sbout =8'hce;
				8'h8c:sbout =8'hf0;
				8'h8d:sbout =8'hb4;
				8'h8e:sbout =8'he6;
				8'h8f:sbout =8'h73;
				8'h90:sbout =8'h96;
				8'h91:sbout =8'hac;
				8'h92:sbout =8'h74;
				8'h93:sbout =8'h22;
				8'h94:sbout =8'he7;
				8'h95:sbout =8'had;
				8'h96:sbout =8'h35;
				8'h97:sbout =8'h85;
				8'h98:sbout =8'he2;
				8'h99:sbout =8'hf9;
				8'h9a:sbout =8'h37;
				8'h9b:sbout =8'he8;
				8'h9c:sbout =8'h1c;
				8'h9d:sbout =8'h75;
				8'h9e:sbout =8'hdf;
				8'h9f:sbout =8'h6e;
				8'ha0:sbout =8'h47;
				8'ha1:sbout =8'hf1;
				8'ha2:sbout =8'h1a;
				8'ha3:sbout =8'h71;
				8'ha4:sbout =8'h1d;
				8'ha5:sbout =8'h29;
				8'ha6:sbout =8'hc5;
				8'ha7:sbout =8'h89;
				8'ha8:sbout =8'h6f;
				8'ha9:sbout =8'hb7;
				8'haa:sbout =8'h62;
				8'hab:sbout =8'h0e;
				8'hac:sbout =8'haa;
				8'had:sbout =8'h18;
				8'hae:sbout =8'hbe;
				8'haf:sbout =8'h1b;
				8'hb0:sbout =8'hfc;
				8'hb1:sbout =8'h56;
				8'hb2:sbout =8'h3e;
				8'hb3:sbout =8'h4b;
				8'hb4:sbout =8'hc6;
				8'hb5:sbout =8'hd2;
				8'hb6:sbout =8'h79;
				8'hb7:sbout =8'h20;
				8'hb8:sbout =8'h9a;
				8'hb9:sbout =8'hdb;
				8'hba:sbout =8'hc0;
				8'hbb:sbout =8'hfe;
				8'hbc:sbout =8'h78;
				8'hbd:sbout =8'hcd;
				8'hbe:sbout =8'h5a;
				8'hbf:sbout =8'hf4;
				8'hc0:sbout =8'h1f;
				8'hc1:sbout =8'hdd;
				8'hc2:sbout =8'ha8;
				8'hc3:sbout =8'h33;
				8'hc4:sbout =8'h88;
				8'hc5:sbout =8'h07;
				8'hc6:sbout =8'hc7;
				8'hc7:sbout =8'h31;
				8'hc8:sbout =8'hb1;
				8'hc9:sbout =8'h12;
				8'hca:sbout =8'h10;
				8'hcb:sbout =8'h59;
				8'hcc:sbout =8'h27;
				8'hcd:sbout =8'h80;
				8'hce:sbout =8'hec;
				8'hcf:sbout =8'h5f;
				8'hd0:sbout =8'h60;
				8'hd1:sbout =8'h51;
				8'hd2:sbout =8'h7f;
				8'hd3:sbout =8'ha9;
				8'hd4:sbout =8'h19;
				8'hd5:sbout =8'hb5;
				8'hd6:sbout =8'h4a;
				8'hd7:sbout =8'h0d;
				8'hd8:sbout =8'h2d;
				8'hd9:sbout =8'he5;
				8'hda:sbout =8'h7a;
				8'hdb:sbout =8'h9f;
				8'hdc:sbout =8'h93;
				8'hdd:sbout =8'hc9;
				8'hde:sbout =8'h9c;
				8'hdf:sbout =8'hef;
				8'he0:sbout =8'ha0;
				8'he1:sbout =8'he0;
				8'he2:sbout =8'h3b;
				8'he3:sbout =8'h4d;
				8'he4:sbout =8'hae;
				8'he5:sbout =8'h2a;
				8'he6:sbout =8'hf5;
				8'he7:sbout =8'hb0;
				8'he8:sbout =8'hc8;
				8'he9:sbout =8'heb;
				8'hea:sbout =8'hbb;
				8'heb:sbout =8'h3c;
				8'hec:sbout =8'h83;
				8'hed:sbout =8'h53;
				8'hee:sbout =8'h99;
				8'hef:sbout =8'h61;
				8'hf0:sbout =8'h17;
				8'hf1:sbout =8'h2b;
				8'hf2:sbout =8'h04;
				8'hf3:sbout =8'h7e;
				8'hf4:sbout =8'hba;
				8'hf5:sbout =8'h77;
				8'hf6:sbout =8'hd6;
				8'hf7:sbout =8'h26;
				8'hf8:sbout =8'he1;
				8'hf9:sbout =8'h69;
				8'hfa:sbout =8'h14;
				8'hfb:sbout =8'h63;
				8'hfc:sbout =8'h55;
				8'hfd:sbout =8'h21;
				8'hfe:sbout =8'h0c;
				8'hff:sbout =8'h7d;
				endcase
end

endmodule




module ror(
    input [31:0] rs1,  // 1st source register 
    input [31:0] rs2,  // 2nd source register 
    output [31:0] rd    // destination register 
);
    wire [4:0] shamt;  // shamt is a 5 bit value extracted from rs2
    assign shamt = rs2[4:0];
    assign rd = (rs1 >> shamt) | (rs1 << (32 - shamt)); // result has rs1 right-shifted by shamt bits
endmodule




module inv_mix_column(
	input [31:0] A,
	input reset,
	input [1:0] bs,
	input enable,
	output [31:0] cypher,
	output  [7:0] out1, 
	output  [7:0] out2,
	output  [7:0] out3,
	output [7:0] out4
);

	reg [7:0] shift_matrix[0:3];
	reg [7:0] temp1,temp2,temp3,temp4; //xor these results to get the final value
	reg [7:0] a,b,c,d; // to be used as intermediates
	reg [7:0] swap;
	reg previous_state;
	integer i;
	
	always @(*) begin
		if(!reset) begin
			previous_state = 0;
		end
		else begin
			case(shift_matrix[0])
				8'b00001110:
					begin
						if(bs == 0) begin
							//multiplication by 0E
							previous_state = 0;
							a = {A[6:0], 1'b0} ^ (8'h1b & {8{A[7]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp1 = a ^ b ^ c;
							
							a = {A[14:8], 1'b0} ^ (8'h1b & {8{A[15]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp2 = a ^ b ^ c;							
							
							a = {A[22:16], 1'b0} ^ (8'h1b & {8{A[23]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp3 = a ^ b ^ c;
							
							a = {A[30:24], 1'b0} ^ (8'h1b & {8{A[31]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp4 = a ^ b ^ c;
							
						end
						else if(bs == 1) begin
							previous_state = 0;
							//multiplication by 0B
							a = A[7:0];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ b ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ b ^ d;
							
							a = A[23:16];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ b ^ d;
							
							a = A[31:24];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp4 = a ^ b ^ d;
						end
						else if(bs == 2) begin
							previous_state = 0;
						
							//multiplying by 0D
							a = A[7:0];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ c ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0} ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ c ^ d;
							
							a = A[23:16];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ c ^ d;
							
							a = A[31:24];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp4 = a ^ c ^ d;
						end
						else begin
							previous_state = 1;
							//multiplying by 09
							a = A[7:0];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ d;
		
							a = A[23:16];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ d;
							
							a = A[31:24];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});	
							temp4 = a ^ d;
						end
					end
				8'b00001011:
					begin
						if(bs == 1) begin
							previous_state = 0;
							//multiplication by 0E
							a = {A[6:0], 1'b0} ^ (8'h1b & {8{A[7]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp1 = a ^ b ^ c;
							
							a = {A[14:8], 1'b0} ^ (8'h1b & {8{A[15]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp2 = a ^ b ^ c;							
							
							a = {A[22:16], 1'b0} ^ (8'h1b & {8{A[23]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp3 = a ^ b ^ c;
							
							a = {A[30:24], 1'b0} ^ (8'h1b & {8{A[31]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp4 = a ^ b ^ c;
							
						end
						else if(bs == 2) begin
							previous_state = 0;
							//multiplication by 0B
							a = A[7:0];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ b ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ b ^ d;
							
							a = A[23:16];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ b ^ d;
							
							a = A[31:24];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp4 = a ^ b ^ d;
						end
						else if(bs == 3) begin
							previous_state = 1;
							//multiplying by 0D
							a = A[7:0];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ c ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0} ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ c ^ d;
							
							a = A[23:16];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ c ^ d;
							
							a = A[31:24];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp4 = a ^ c ^ d;
						end
						else begin
							previous_state = 0;
							
							//multiplying by 09
							a = A[7:0];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ d;
		
							a = A[23:16];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ d;
							
							a = A[31:24];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});	
							temp4 = a ^ d;
							
							
						end
					end
				8'b00001101:
					begin
						if(bs == 2) begin
							previous_state = 0;
							
							//multiplication by 0E
							a = {A[6:0], 1'b0} ^ (8'h1b & {8{A[7]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp1 = a ^ b ^ c;
							
							a = {A[14:8], 1'b0} ^ (8'h1b & {8{A[15]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp2 = a ^ b ^ c;							
							
							a = {A[22:16], 1'b0} ^ (8'h1b & {8{A[23]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp3 = a ^ b ^ c;
							
							a = {A[30:24], 1'b0} ^ (8'h1b & {8{A[31]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp4 = a ^ b ^ c;
							
						end
						else if(bs == 3) begin
							previous_state = 1;
							//multiplication by 0B
							a = A[7:0];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ b ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ b ^ d;
							
							a = A[23:16];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ b ^ d;
							
							a = A[31:24];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp4 = a ^ b ^ d;
						end
						else if(bs == 0) begin
							previous_state = 0;
							//multiplying by 0D
							a = A[7:0];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ c ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0} ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ c ^ d;
							
							a = A[23:16];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ c ^ d;
							
							a = A[31:24];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp4 = a ^ c ^ d;
						end
						else begin
							previous_state = 0;
							//multiplying by 09
							a = A[7:0];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ d;
		
							a = A[23:16];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ d;
							
							a = A[31:24];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});	
							temp4 = a ^ d;
							
							
						end
					end
				8'b00001001:
					begin
						if(bs == 3) begin
							previous_state = 1;
							//multiplication by 0E
							a = {A[6:0], 1'b0} ^ (8'h1b & {8{A[7]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp1 = a ^ b ^ c;
							
							a = {A[14:8], 1'b0} ^ (8'h1b & {8{A[15]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp2 = a ^ b ^ c;							
							
							a = {A[22:16], 1'b0} ^ (8'h1b & {8{A[23]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp3 = a ^ b ^ c;
							
							a = {A[30:24], 1'b0} ^ (8'h1b & {8{A[31]}});
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							temp4 = a ^ b ^ c;
							previous_state = 1;
						end
						else if(bs == 0) begin
							previous_state = 0;
							//multiplication by 0B
							a = A[7:0];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ b ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ b ^ d;
							
							a = A[23:16];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ b ^ d;
							
							a = A[31:24];
							b = {a[6:0], 1'b0} ^ (8'h1b & {8{a[7]}});
							c = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp4 = a ^ b ^ d;
						end
						else if(bs == 1) begin
							previous_state = 0;
							//multiplying by 0D
							a = A[7:0];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ c ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0} ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ c ^ d;
							
							a = A[23:16];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ c ^ d;
							
							a = A[31:24];
							b = {a[6:0] , 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp4 = a ^ c ^ d;
						end
						else begin
							previous_state = 0;
							//multiplying by 09
							a = A[7:0];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp1 = a ^ d;
							
							a = A[15:8];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp2 = a ^ d;
		
							a = A[23:16];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});
							temp3 = a ^ d;
							
							a = A[31:24];
							b = {a[6:0], 1'b0} ^ {8'h1b & {8{a[7]}}};
							c = {b[6:0], 1'b0 } ^ {8'h1b & {8{b[7]}}};
							d = {c[6:0], 1'b0} ^ (8'h1b & {8{c[7]}});	
							temp4 = a ^ d;
						end
					end
			endcase
		end
	end
	
	always @(negedge previous_state, negedge reset) begin
		if(!reset) begin
			shift_matrix[0] = 8'b00001110;
			shift_matrix[1] = 8'b00001011;
			shift_matrix[2] = 8'b00001101;
			shift_matrix[3] = 8'b00001001;
		end
		else if(enable) begin
	    swap = shift_matrix[0];
        shift_matrix[0] = shift_matrix[1];
        shift_matrix[1] = shift_matrix[2];
        shift_matrix[2] = shift_matrix[3];
        shift_matrix[3] = swap;
		end
		else begin
		shift_matrix[0] = 8'b00001110;
                    shift_matrix[1] = 8'b00001011;
                    shift_matrix[2] = 8'b00001101;
                    shift_matrix[3] = 8'b00001001;
         end          
	end
	
	assign cypher = {temp4, temp3, temp2, temp1};
	assign out1 = shift_matrix[0];
	assign out2 = shift_matrix[1];
	assign out3 = shift_matrix[2];
	assign out4 = shift_matrix[3];
endmodule



module sha256sig0(
    input [31:0] rs1,
    output [31:0] rd
    );
    wire [31:0] ror32a;
    wire [31:0] ror32b;
    wire [31:0] ror;
    rori inst1(
        .rs1(rs1),
        .shamt(7),
        .rd(ror32a)
        );
    rori inst2(
        .rs1(rs1),
        .shamt(18),
        .rd(ror32b)
        );
    assign ror = rs1 >> 3;
    assign rd = ror32a^ror32b^ror;
endmodule




module rori(
       input [31:0] rs1,
       input [4:0] shamt,
       output [31:0] rd
    );
    assign rd = (rs1 >> shamt) | (rs1 << (32 - shamt));
endmodule


module sha256sig1(
    input [31:0] rs1,
    output [31:0] rd
    );
    wire [31:0] ror32a;
    wire [31:0] ror32b;
    wire [31:0] ror;
    rori inst1(
        .rs1(rs1),
        .shamt(17),
        .rd(ror32a)
        );
    rori inst2(
        .rs1(rs1),
        .shamt(19),
        .rd(ror32b)
        );
    assign ror = rs1 >> 10;
    assign rd = ror32a^ror32b^ror;
endmodule




module sha256sum0(
    input [31:0] rs1,
    output [31:0] rd
    );
    wire [31:0] ror32a;
    wire [31:0] ror32b;
    wire [31:0] ror32c;
    rori inst1(
        .rs1(rs1),
        .shamt(2),
        .rd(ror32a)
        );
    rori inst2(
        .rs1(rs1),
        .shamt(13),
        .rd(ror32b)
        );
    rori inst3(
         .rs1(rs1),
         .shamt(22),
         .rd(ror32c)
        );
    assign rd = ror32a^ror32b^ror32c;
endmodule



module sha256sum1(
    input [31:0] rs1,
    output [31:0] rd
    );
    wire [31:0] ror32a;
    wire [31:0] ror32b;
    wire [31:0] ror32c;
    rori inst1(
        .rs1(rs1),
        .shamt(6),
        .rd(ror32a)
        );
    rori inst2(
        .rs1(rs1),
        .shamt(11),
        .rd(ror32b)
        );
    rori inst3(
         .rs1(rs1),
         .shamt(25),
         .rd(ror32c)
        );
    assign rd = ror32a^ror32b^ror32c;
endmodule
