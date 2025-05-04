class uart_rx_driver extends uvm_driver #(uart_packet);
  `uvm_component_utils(uart_rx_driver)
  virtual uart_if vif;
// Constructor
  function new(string name = "uart_rx_driver", uvm_component parent);
         super.new(name, parent);
 `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

  endfunction
// build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      `uvm_info(get_type_name(), "Build Phase!", UVM_HIGH)

    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal("RX_DRIVER", "Failed to get interface handle")
  endfunction

//connect_phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "Connect Phase!", UVM_HIGH)
  endfunction

//run_phase
  task run_phase(uvm_phase phase);
       super.run_phase(phase);
    `uvm_info(get_type_name(), "\nInside Run Phase!", UVM_HIGH)

    // forever begin
    // //   seq_item_port.get_next_item(req);
    // //   vif.tx <= req.data;
    // //   seq_item_port.item_done();
    // end
  endtask

 function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "start of simulation phase", UVM_HIGH)
  endfunction
endclass