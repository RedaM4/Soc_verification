class demo_base_test extends uvm_test;

  `uvm_component_utils(demo_base_test)

  demo_tb tb;

  function new(string name = "demo_base_test", 
    uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Enable transaction recording for everything
    uvm_config_int::set(this,"*", "recording_detail", UVM_FULL);
    // Create the tb
    tb = demo_tb::type_id::create("tb", this);
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  function void check_phase(uvm_phase phase);
    check_config_usage();
  endfunction

endclass : demo_base_test




//----------------------------------------------------------------
// TEST: write-read  write  1 byte to data register of spi  then read 1 byte from it  
//----------------------------------------------------------------
class i2c_write_read_test extends demo_base_test;

  `uvm_component_utils(i2c_write_read_test)

  function new(string name = get_type_name(), uvm_component parent=null);
    super.new(name,parent);
  endfunction : new




  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this,10ns);
  endtask : run_phase


  virtual function void build_phase(uvm_phase phase);

    // Set the default sequence for the master and slave
    uvm_config_wrapper::set(this, "tb.i2c.masters[0].sequencer.main_phase",
                            "default_sequence",
                            i2c_write_read_seq::get_type());



    super.build_phase(phase);
  endfunction : build_phase

endclass : i2c_write_read_test



