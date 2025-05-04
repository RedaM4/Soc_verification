interface uart_if #(parameter CLOCK_FREQ = 192000) (input clk);
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import uart_pkg::*;

    bit tx=1, rx=1;
    int baud_rate = 9600;
   bit txparity_mode;
   bit parity_mode;

 task tx_2_rx(input uart_packet packet);
    int baud_counter = 0;
    int baud_limit = 0;
    logic parity_bit = 0;
    logic [10:0] shift_reg;  // Start bit, 8 data bits, parity bit, Stop bit
    baud_limit = (CLOCK_FREQ / baud_rate) - 1;
        //req.baud_rate = 9600; 

parity_bit = parity_calc(packet.data[7:0], packet.parity_mode) ; 

txparity_mode = packet.parity_mode;

    shift_reg = {1'b1, parity_bit, packet.data[7:0], 1'b0};


for (int i = 0; i < 11; i++) begin
        baud_counter = 0;
        @(negedge clk);  // Sync with the clock edge
        tx <= shift_reg[i];  // Send bit

        // rx <= tx;

        // Wait for full bit time (baud rate)
        while (baud_counter < baud_limit) begin
            @(negedge clk);  // Wait for next clock edge
            baud_counter++;
        end
        if (baud_counter == baud_limit) begin
            rx <= tx;
        end


    end


    //rx=0 ; 
    $display("sent shift_reg: %b", shift_reg);  // Show the 8 bits of data

endtask


  task rx_2_data(output bit [7:0] data);
    logic [10:0] shift_reg = 11'h0;  // 11 bits: start, 8 data, parity, stop
    logic [2:0] sample_bits;
     int baud_limit = 0;
    int baud_counter = 0;
 logic expected_parity ;
    logic received_parity ;
        int rxerror_counter=0 ; 

    baud_limit = (CLOCK_FREQ / baud_rate) - 1;



    // wait(rx == 0);  // Wait for start bit (1)
@(negedge rx);
    repeat (baud_limit / 2) @(negedge clk);  // center of first bit

    for (int i = 0; i < 11; i++) begin
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);  
        sample_bits[0] = rx;
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);
        sample_bits[1] = rx;
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);
        sample_bits[2] = rx;
        // Majority voting logic for each bit
     
        shift_reg[i] = (sample_bits[0] & sample_bits[1]) | (sample_bits[1] & sample_bits[2]) | (sample_bits[0] & sample_bits[2]);
    end

    // Reversed order (LSB first)
    
    data = shift_reg[8:1];  // Extract the 8 data bits, LSB first
//packet.parity_mode = txparity_mode ; 
  expected_parity = parity_calc(data, txparity_mode);
     received_parity = shift_reg[9];

     if (expected_parity !== received_parity)begin
        rxerror_counter++ ; 
        $display("❌RX Parity mismatch: expected %b, received %b, errors: %2d", expected_parity, received_parity,rxerror_counter );
    end else begin 
        $display("✅RX Parity OK, errors: %2d",rxerror_counter );

    end


       // Display the entire received packet (including start, data, and stop bits)
    $display("\n\nRXReceived Packet (stop bit +Parity bit  +Data bits  + Start bit):");
    $display("Start Bit: %b", shift_reg[0]);  // Start bit (should be 0)
    $display("Data Bits: %b", shift_reg[8:1]);  // Data bits (8 bits)
    $display("Parity Bit: %b", shift_reg[9]);  // Parity bit (you can add parity check logic here)
    $display("Stop Bit: %b", shift_reg[10]);  // Stop bit (should be 1)
if (txparity_mode) begin
$display("parity is even");
    
end else
$display("parity is odd");

    // Display the extracted data
    $display("Extracted shift_reg: %b", shift_reg);  // Show the 8 bits of data


endtask


function logic parity_calc(input logic [7:0] data, input bit mode);
    if (mode == 1)
        parity_calc = ~^data;
    else
        parity_calc = ^data;
endfunction

//-----------------------------rx 2 tx ----------------------------------------


 task rx_2_tx(input uart_packet packet);
    int baud_counter = 0;
    int baud_limit = 0;
    logic parity_bit = 0;
    logic [10:0] shift_reg;  // Start bit, 8 data bits, parity bit, Stop bit
    baud_limit = (CLOCK_FREQ / baud_rate) - 1;
        //req.baud_rate = 9600; 

parity_bit = parity_calc(packet.data[7:0], packet.parity_mode) ; 

parity_mode = packet.parity_mode;

    shift_reg = {1'b1, parity_bit, packet.data[7:0], 1'b0};


for (int i = 0; i < 11; i++) begin
        baud_counter = 0;
        @(negedge clk);  // Sync with the clock edge
        rx <= shift_reg[i];  // Send bit

        // rx <= tx;

        // Wait for full bit time (baud rate)
        while (baud_counter < baud_limit) begin
            @(negedge clk);  // Wait for next clock edge
            baud_counter++;
        end
        if (baud_counter == baud_limit) begin
            tx <= rx;
        end


    end


    //rx=0 ; 
    $display("sent shift_reg: %b", shift_reg);  // Show the 8 bits of data

endtask


  task tx_2_data(output bit [7:0] data);
    logic [10:0] shift_reg = 11'h0;  // 11 bits: start, 8 data, parity, stop
    logic [2:0] sample_bits;
     int baud_limit = 0;
    int baud_counter = 0;
 logic expected_parity ;
    logic received_parity ;
    int txerror_counter=0 ; 
    baud_limit = (CLOCK_FREQ / baud_rate) - 1;



    // wait(rx == 0);  // Wait for start bit (1)
@(negedge tx);
    repeat (baud_limit / 2) @(negedge clk);  // center of first bit

    for (int i = 0; i < 11; i++) begin
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);  
        sample_bits[0] = tx;
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);
        sample_bits[1] = tx;
        repeat ((CLOCK_FREQ / baud_rate) / 3) @(negedge clk);
        sample_bits[2] = tx;
        // Majority voting logic for each bit
     
        shift_reg[i] = (sample_bits[0] & sample_bits[1]) | (sample_bits[1] & sample_bits[2]) | (sample_bits[0] & sample_bits[2]);
    end

    // Reversed order (LSB first)
    
    data = shift_reg[8:1];  // Extract the 8 data bits, LSB first

  expected_parity = parity_calc(data, parity_mode);
     received_parity = shift_reg[9];

    if (expected_parity !== received_parity)begin
        txerror_counter++ ; 
        $display("❌TX Parity mismatch: expected %b, received %b, errors: %2d", expected_parity, received_parity,txerror_counter );
    end else begin 
        $display("✅TX Parity OK, errors: %2d",txerror_counter );

    end

       // Display the entire received packet (including start, data, and stop bits)
    $display("\n\nTX Received Packet (stop bit +Parity bit  +Data bits  + Start bit):");
    $display("Start Bit: %b", shift_reg[0]);  // Start bit (should be 0)
    $display("Data Bits: %b", shift_reg[8:1]);  // Data bits (8 bits)
    $display("Parity Bit: %b", shift_reg[9]);  // Parity bit (you can add parity check logic here)
    $display("Stop Bit: %b", shift_reg[10]);  // Stop bit (should be 1)
if (parity_mode) begin
$display("parity is even");
    
end else
$display("parity is odd");
    // Display the extracted data
    $display("Extracted shift_reg: %b", shift_reg);  // Show the 8 bits of data


endtask





endinterface