// i2c transaction enums, parameters, and events
typedef enum bit  {i2c_read, i2c_write} op_type_enum; //from master POV 


class i2c_transaction extends uvm_sequence_item;     


static int data_width=8;

  // Constant  for configurable widths
  localparam  int ADDR_WIDTH = 32;
  localparam  int DATA_WIDTH = 8;


//variables
  rand logic [ADDR_WIDTH-1:0] addr;
  rand logic [DATA_WIDTH-1:0] din;
  logic [DATA_WIDTH-1:0] dout;
  rand op_type_enum op_type;
  rand bit  valid_sb;  // to till the scoreboard  wither the transaction is dummy or real  



  `uvm_object_utils_begin(i2c_transaction)
    `uvm_field_enum(op_type_enum, op_type, UVM_DEFAULT)
    //`uvm_field_int(length, UVM_DEFAULT | UVM_DEC)
    //`uvm_field_array_int(payload, UVM_DEFAULT)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_int(din, UVM_DEFAULT)
    `uvm_field_int(dout, UVM_DEFAULT)
    `uvm_field_int(valid_sb, UVM_DEFAULT)
    `uvm_object_utils_end


  //constraint payload_length { length > 0; length == payload.size(); }
  //constraint limit_length { length <= 4 ;} // since FIFO of SPI is 4 entries deep 
  constraint addr_limit {addr >= 0;  addr <= 'hff;  }
  



  function new (string name = "i2c_transaction");
    super.new(name);
  endfunction : new



  function void post_randomize();

  endfunction :post_randomize




endclass : i2c_transaction