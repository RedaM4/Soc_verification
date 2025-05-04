class uart_tx_agent extends uvm_agent;
  `uvm_component_utils(uart_tx_agent)

  uart_tx_driver drv;
  uart_tx_monitor mon;
  uart_tx_sequencer seqr;

  function new(string name ="uart_tx_agent", uvm_component parent);
          super.new(name, parent);
`uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

  endfunction

  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "Build Phase!", UVM_HIGH)

    drv = uart_tx_driver::type_id::create("drv", this);
    mon = uart_tx_monitor::type_id::create("mon", this);
    seqr = uart_tx_sequencer::type_id::create("seqr", this);
  endfunction

  function void connect_phase(uvm_phase phase);
          super.connect_phase(phase);
      `uvm_info(get_type_name(), "Connect Phase!", UVM_HIGH)

           drv.seq_item_port.connect(seqr.seq_item_export);

          `uvm_info(get_type_name(), "after this Phase!", UVM_HIGH)

  endfunction

    function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "start of simulation phase", UVM_HIGH)
    endfunction
endclass