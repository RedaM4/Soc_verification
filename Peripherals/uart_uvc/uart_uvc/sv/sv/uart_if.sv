interface uart_if #(parameter CLOCK_FREQ = 50_000) (input clk);
 `include "uvm_macros.svh"
  import uvm_pkg::*;
   import uart_pkg::*;

   logic tx, rx;

   task tx_2_rx(input uart_packet packet);
      int baud_counter = 0;
      int baud_limit=0;
      logic parity_bit;
      logic [10:0] shift_reg;  // Start bit, 8 data bits, parity bit, Stop bit
      baud_limit = (CLOCK_FREQ / packet.baud_rate) - 1; 

      // Calculate Parity
      parity_bit = calc_parity(packet.data, packet.parity_mode);

      shift_reg = {1'b0, packet.data, parity_bit, 1'b1};

      // Start Transmission
      for (int i = 0; i < 11; i++) begin

         baud_counter = 0;

            tx <= shift_reg[i];
         while (baud_counter < baud_limit) begin
            @(posedge clk);
                                   
             if (baud_counter == baud_limit / 2) begin
                 rx <= tx;end

            baud_counter++;
         end

      end

   endtask

   // Function to Calculate Parity
   function logic calc_parity(input logic [7:0] data, input bit parity_type);
      case (parity_type)
         1'b0: calc_parity = ^data;     // Even parity
         1'b1: calc_parity = ~(^data);  // Odd parity
      endcase
   endfunction

endinterface