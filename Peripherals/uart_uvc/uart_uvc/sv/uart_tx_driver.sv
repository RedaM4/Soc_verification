class uart_tx_driver extends uvm_driver #(uart_packet);
    `uvm_component_utils(uart_tx_driver)

    virtual  uart_if vif;
    uart_packet pkt;

    // Constructor
    function new(string name = "uart_tx_driver", uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "Build Phase!", UVM_HIGH)
    endfunction

    // Connect Phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "Connect Phase!", UVM_HIGH)

        if (!uart_vif_config::get(this, "*", "vif", vif))
            `uvm_fatal("TX_DRIVER", "Failed to get interface handle")
    endfunction
  

  //tx driver
task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "\nInside Run Phase!", UVM_HIGH)
    //vif.tx = 1;
    forever begin
        `uvm_info(get_type_name(), "Waiting for next item from sequencer here at drv", UVM_HIGH)
        seq_item_port.get_next_item(req);

        req.baud_rate = 9600; 
    //    req.parity_mode = 0 ; 
        vif.tx_2_rx(req);
        `uvm_info("z FROM TX DRV SENT", $sformatf("sent packet:\n%s", req.sprint()), UVM_HIGH)
    //   #10;
        seq_item_port.item_done();
        `uvm_info(get_type_name(), "Item done", UVM_HIGH)
    end
endtask


    // Start of Simulation Phase
    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "start of simulation phase", UVM_HIGH)
    endfunction
endclass