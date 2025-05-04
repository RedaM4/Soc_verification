
class uart_env extends uvm_env;
  `uvm_component_utils(uart_env)

  uart_tx_agent tx_agent;
  uart_rx_agent rx_agent;

  function new(string name="uart_env", uvm_component parent);
          super.new(name, parent);
`uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

  endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);  // Ensure parent class build is executed
    `uvm_info(get_type_name(), "Inside Build Phase!", UVM_HIGH)
    
    tx_agent = uart_tx_agent::type_id::create("tx_agent", this);
    //rx_agent = uart_rx_agent::type_id::create("rx_agent", this);
endfunction


  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);  // Ensure parent class build is executed

        `uvm_info(get_type_name(), "Inside Connect Phase!", UVM_HIGH)

    // Connect analysis ports if needed
  endfunction
endclass