typedef enum bit {ODD_PARITY, EVEN_PARITY} parity_mode_t;

class uart_packet extends uvm_sequence_item;
  `uvm_object_utils_begin(uart_packet)
    `uvm_field_int(data, UVM_ALL_ON | UVM_HEX)
    `uvm_field_enum(parity_mode_t, parity_mode, UVM_ALL_ON)
    `uvm_field_int(baud_rate, UVM_ALL_ON)
  `uvm_object_utils_end

  rand bit [7:0] data;          
  rand parity_mode_t parity_mode; // 0 = Even, 1 = Odd
  rand int baud_rate; 

  constraint baud_rate_c {
      baud_rate inside {4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800, 921600};}
  constraint data_c { data inside {[0:255]}; } 
  constraint parity_c { parity_mode inside {ODD_PARITY, EVEN_PARITY}; } 

  function new(string name = "uart_packet");
    super.new(name);
    baud_rate = 9600; 
  endfunction
    function void print();
        $display("------------------------- Packet Details -----------------------");
        $display("Data: %h", data);
        $display("Parity Mode: %b", parity_mode);
        $display("Baud Rate: %0d", baud_rate);
        $display("---------------------------------------------------------------");
    endfunction
endclass