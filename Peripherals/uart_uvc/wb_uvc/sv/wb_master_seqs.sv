//need to figure out the sequences to be generated


class wb_master_sequence extends uvm_sequence #(n_cpu_transaction);
  
  `uvm_object_utils(wb_master_sequence)

  function new(string name="wb_master_sequence");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
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
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body



endclass : wb_master_sequence




class five_uart_random extends wb_master_sequence;
  
  // Required macro for sequences automation
  `uvm_object_utils(five_uart_random)

  // Constructor
  function new(string name="five_uart_random");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing 5 random uart calls", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : five_uart_random

/*
class yapp_012_seq extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_012_seq)

  // Constructor
  function new(string name="yapp_012_seq");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_012_packet sequence", UVM_LOW)
      `uvm_do_with(req, {addr==0;});
      `uvm_do_with(req, {addr==1;});
      `uvm_do_with(req, {addr==2;});
  //    `uvm_do_with(req, {addr==3;});
  endtask



endclass : yapp_012_seq
*/
