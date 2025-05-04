
class slave_base_seq extends uvm_sequence #(i2c_transaction);

  // Required macro for sequences automation
  `uvm_object_utils(slave_base_seq)

  string phase_name;
  uvm_phase phaseh;

  // Constructor
  function new(string name = "slave_base_seq");
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

endclass : slave_base_seq





//------------------------------------------------------------------------------
// SEQUENCE: empty sequance - Send an empty transaction to mimic the SPI response (handled in the driver).
//------------------------------------------------------------------------------
class i2c_empty_seq extends slave_base_seq;

  function new(string name = get_type_name());
    super.new(name);
  endfunction

  `uvm_object_utils(i2c_empty_seq)

  virtual task body();
    `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)
    
    `uvm_create(req)
    `uvm_send(req)


    `uvm_info(get_type_name(), $sformatf("i2c WRITE ADDRESS:%0d  DATA:%h", req.addr, req.din), UVM_MEDIUM)

  endtask : body


endclass : i2c_empty_seq

