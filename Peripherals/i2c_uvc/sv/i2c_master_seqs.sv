
class i2c_base_seq extends uvm_sequence #(i2c_transaction);

  // Required macro for sequences automation
  `uvm_object_utils(i2c_base_seq)

  string phase_name;
  uvm_phase phaseh;

  // Constructor
  function new(string name = "i2c_base_seq");
    super.new(name);
  endfunction


  task pre_body();
    uvm_phase phase;
`ifdef UVM_VERSION_1_2
    // in UVM1.2, get starting phase from method
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body


  task post_body();
    uvm_phase phase;
`ifdef UVM_VERSION_1_2
    // in UVM1.2, get starting phase from method
    phase = get_starting_phase();
`else
    phase = starting_phase;
`endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : i2c_base_seq





//------------------------------------------------------------------------------
// SEQUENCE: i2c_write_read_seq -  write byte to spi1 peripheral (addr 2 spi data register) then dumy read from data reg to empty the read fifo of the spi
//------------------------------------------------------------------------------

class i2c_write_read_seq extends i2c_base_seq ;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(i2c_write_read_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

    
    
    // `uvm_do_with(req,
    //              { op_type == i2c_write ; // we =1
    //                addr == 0; // enable spi by setting the control register 
    //                din==8'b01110000;  // 7:disable inta 6:en spi 5:reserved 4:set spi as master 3:S_polarity 2: S_phase  [1:0]: sclk=clk/2
    //                valid_sb==0;// indecate write sequnnace

    //                })


       
    // `uvm_do_with(req,
    //              { op_type == i2c_write ; 
    //                addr == 4;        //manually control CS singal through  register 4
    //                din==8'b0000001;  // [0]:  1 to clear Cs     0 to set cs
    //                valid_sb==0;// indecate write sequnnace

    //                })
   
   
   
    // `uvm_do_with(req,
    //              { op_type == i2c_write ; // write a random data to data register 
    //                addr == 2;
    //                valid_sb==1;// indecate write sequnnace

    //                }
    //             )

    //   #160;      //stalling until spi send out the byte serially on mosi   
          
    // `uvm_do_with(req,
    //              { op_type == i2c_write ; 
    //                addr == 4; //manually control CS singal through  register 4
    //                din==8'b0000000;  // [0]:  1 to clear Cs     0 to set cs
    //                valid_sb==0;// indecate write sequnnace

    //                })




    // `uvm_do_with(req,
    //              { op_type == i2c_read ;
    //                addr == 2;
    //                valid_sb==0;// indecate write sequnnace
    //                } //sending read requist to data reg to empty the garbge from read fifo
    //             )
   
   

//    `uvm_info(get_type_name(), $sformatf("i2c WRITE ADDRESS:%0d  DATA:%h", req.addr, req.din), UVM_MEDIUM)

  endtask : body


endclass : i2c_write_read_seq
