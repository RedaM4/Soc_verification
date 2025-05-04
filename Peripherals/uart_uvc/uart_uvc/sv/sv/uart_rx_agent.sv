class uart_rx_agent extends uvm_agent;
  `uvm_component_utils(uart_rx_agent)

  uart_rx_driver drv;
  uart_rx_monitor mon;
  uart_rx_sequencer seqr;

  function new(string name ="uart_rx_agent", uvm_component parent);
         super.new(name, parent);
 `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

  endfunction

  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "Build Phase!", UVM_HIGH)

    drv = uart_rx_driver::type_id::create("drv", this);
   // mon = uart_rx_monitor::type_id::create("mon", this);
    seqr = uart_rx_sequencer::type_id::create("seqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
                 super.connect_phase(phase);
`uvm_info(get_type_name(), "Connect Phase!", UVM_HIGH)

    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

    function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "start of simulation phase", UVM_HIGH)
    endfunction
endclass