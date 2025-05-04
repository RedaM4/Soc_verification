class wb_tb extends uvm_env;

  `uvm_component_utils(wb_tb)

  wb_env env;
  //clock_and_reset_env clk_n_rst;
  wb_scoreboard scoreboard;  

  function new(string name = "wb_tb", uvm_component parent);
    super.new(name,parent); 
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = wb_env::type_id::create("env",this); 
    ///clk_n_rst = clock_and_reset_env::type_id::create("clk_n_rst",this);
    scoreboard = wb_scoreboard::type_id::create("scoreboard",this);  
  endfunction

function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    env.master_agent.monitor.mon_ap.connect(scoreboard.master_imp);
    env.slave_agent.monitor.mon_ap.connect(scoreboard.slave_imp);
    `uvm_info("CONNECT", "Scoreboard connected to both master and slave monitors", UVM_MEDIUM)
endfunction
endclass: wb_tb
