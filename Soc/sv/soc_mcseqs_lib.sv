class soc_mcseq_lib extends uvm_sequence ;
    `uvm_object_utils(soc_mcseq_lib)

  function new(string name="soc_mcseq_lib");
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

endclass : soc_mcseq_lib



class router_simple_mcseq extends base_seq;
  
    `uvm_object_utils(router_simple_mcseq)

`uvm_declare_p_sequencer(uart_var_mcsequencer)
  DataGen_seq DataGen;
  uart_5_seq uart_seq;

  function new(string name = "router_simple_mcseq");
    super.new(name);
    `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)
  endfunction: new


  task body();
    `uvm_info(get_type_name(), "Starting UART Master Control Sequence", UVM_MEDIUM)
    // `uvm_do_on(DataGen, p_sequencer.wb_seqr)
    // `uvm_do_on(uartSeq, p_sequencer.wb_seqr)
    `uvm_info(get_type_name(), "Finished UART Master Control Sequence", UVM_MEDIUM)
  endtask
endclass 