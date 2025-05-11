class soc_tb extends uvm_env;
        `uvm_component_utils(soc_tb)


// uart_env uartenv ; 
wb_env wbenv ; 
clock_and_reset_env clk_rst_env ; 
soc_ref_env soc_refenv; 
spi_env spi_env;

  // spi_module spiref;

    function new(string name = "soc_tb",uvm_component parent);
            super.new(name, parent);
           `uvm_info(get_type_name(), "Inside Constructor!", UVM_LOW)
    endfunction //new()

   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // uartenv = uart_env::type_id::create("uartenv", this);
    spi_env = spi_env::type_id::create("spi_env", this);

    wbenv = wb_env::type_id::create("wbenv", this);
    clk_rst_env = clock_and_reset_env::type_id::create("clk_rst_env", this);
    soc_refenv = soc_ref_env::type_id::create("soc_refenv", this); 

    endfunction



 function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //sequencers connection to mc_seqr
     soc_mcsequencer.wb_seqr = wbenv.master_agent.sequencer;  
    soc_mcsequencer.spi_s_seqr =spi1.master_agent.seqr;


    //wb to soc_ref
    wbenv.master_agent.monitor.mon_ap.connect(soc_refenv.soc_ref.wb_in);
    // TLM connections between spi and Scoreboard
    spi_env.master_agent.mon.spi_out.connect(soc_refenv.scb.spi_in1); 

   // TLM connections between Refrence model and scoreborad 
    soc_refenv.sref_model.ref_analysis_port.connect(soc_refenv.scb.ref_in);

    endfunction


  //--------------------------------------------------------
  //start_of_simulation_phase
  //--------------------------------------------------------
function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation", UVM_HIGH)
endfunction



endclass