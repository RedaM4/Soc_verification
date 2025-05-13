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



class spi_simple_seq extends soc_mcseq_lib;
  
    `uvm_object_utils(spi_simple_seq)

`uvm_declare_p_sequencer(soc_mcsequencer)

//spi_m_seqr

  enable_spi_core enable_spi;
  // uart_5_seq uart_seq;
spi_slave_write_seq spi_s_write ; 

  function new(string name = "router_simple_mcseq");
    super.new(name);
    `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)
  endfunction: new


  task body();
    // `uvm_info(get_type_name(), "Starting UART Master Control Sequence", UVM_MEDIUM)
    `uvm_do_on(enable_spi, p_sequencer.wb_seqr)
     `uvm_do_on(spi_s_write, p_sequencer.spi_s_seqr)

    // `uvm_info(get_type_name(), "Finished UART Master Control Sequence", UVM_MEDIUM)
  endtask
endclass 