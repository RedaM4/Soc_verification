module seven_seg_decoder(
    input  wire [3:0] bin,      // 4-bit binary input (0–F)
    output reg  [6:0] seg       // 7-bit output for segments a-g
);
    // Define the segment patterns for each hexadecimal digit
    always @(*) begin
        case (bin)
            4'h0: seg = 7'b1000000; // Display 0
            4'h1: seg = 7'b1111001; // Display 1
            4'h2: seg = 7'b0100100; // Display 2
            4'h3: seg = 7'b0110000; // Display 3
            4'h4: seg = 7'b0011001; // Display 4
            4'h5: seg = 7'b0010010; // Display 5 
            4'h6: seg = 7'b0000010; // Display 6 
            4'h7: seg = 7'b1111000; // Display 7 
            4'h8: seg = 7'b0000000; // Display 8
            4'h9: seg = 7'b0010000; // Display 9 
            4'hA: seg = 7'b0001000; // Display A
            4'hB: seg = 7'b0000011; // Display B 
            4'hC: seg = 7'b1000110; // Display C 
            4'hD: seg = 7'b0100001; // Display D 
            4'hE: seg = 7'b0000110; // Display E 
            4'hF: seg = 7'b0001110; // Display F 
            default: seg = 7'b1111111; // Default to all segments OFF
        endcase
    end
endmodule
