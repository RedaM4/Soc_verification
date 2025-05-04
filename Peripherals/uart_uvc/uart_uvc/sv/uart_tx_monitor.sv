class uart_tx_monitor extends uvm_monitor;
  `uvm_component_utils(uart_tx_monitor)
  
  virtual uart_if vif;
  // uvm_analysis_port#(uart_packet) mon_ap;
  uart_packet pkt;

//Constructor
  function new(string name= "uart_tx_monitor", uvm_component parent);
         super.new(name, parent);
 `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

    // mon_ap = new("mon_ap", this);
  endfunction
//build_phase
  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info(get_type_name(), "Build Phase!", UVM_HIGH)

    if (!uvm_config_db#(virtual uart_if)::get(this, "", "vif", vif))
      `uvm_fatal("TX_MONITOR", "Failed to get interface handle")
  endfunction

//connect_phase
 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "Connect Phase!", UVM_HIGH)
  endfunction: connect_phase
  

task run_phase(uvm_phase phase);
    pkt = uart_packet::type_id::create("pkt");
       
       forever begin
          @(posedge vif.clk);
        vif.tx_2_data(pkt.data);
       `uvm_info("y FROM TX MON RECEIVED", $sformatf("Received packet:\n%s", pkt.sprint()), UVM_HIGH)
       end

endtask


    function void start_of_simulation_phase(uvm_phase phase);
            `uvm_info(get_type_name(), "start of simulation phase", UVM_HIGH)
    endfunction
endclass

