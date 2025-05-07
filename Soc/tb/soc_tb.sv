class soc_tb extends uvm_env;
        `uvm_component_utils(soc_tb)


uart_env uartenv ; 
wb_env wbenv ; 
clock_and_reset_env clk_rst_env ; 
big_scoreboard scoreboard; 

    function new(string name = "soc_tb",uvm_component parent);
            super.new(name, parent);
           `uvm_info(get_type_name(), "Inside Constructor!", UVM_LOW)
    endfunction //new()

   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uartenv = uart_env::type_id::create("uartenv", this);
    wbenv = wb_env::type_id::create("wbenv", this);
    clk_rst_env = clock_and_reset_env::type_id::create("clk_rst_env", this);
    scoreboard = big_scoreboard::type_id::create("scoreboard", this); 


    endfunction



 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // uartenv.tx_agent.mon.mon_ap_tx.connect(scoreboard.uart_tx_imp);
    uartenv.rx_agent.mon.mon_ap_rx.connect(scoreboard.uart_rx_imp);
    wbenv.master_agent.monitor.mon_ap.connect(scoreboard.wb_master_imp);
    endfunction


  //--------------------------------------------------------
  //start_of_simulation_phase
  //--------------------------------------------------------
function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation", UVM_HIGH)
endfunction



endclass