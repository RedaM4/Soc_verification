class soc_mcsequencer extends uvm_sequencer;
  `uvm_component_utils(soc_mcsequencer)



    // uart_rx_sequencer  uart_seqr ; 
    wb_master_sequencer wb_seqr; 
spi_slave_sequencer spi_s_seqr ; 
  //--------------------------------------------------------
  //Constructor
  //--------------------------------------------------------
  function new(string name = "soc_mcsequencer", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)
  endfunction: new

  
endclass //router_mcsequencer extends uvm_sequencer