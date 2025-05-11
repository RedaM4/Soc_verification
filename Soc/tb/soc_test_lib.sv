class base_test extends uvm_test;   
         `uvm_component_utils(base_test)

    soc_tb tb ; 

    function new(string name = "base_test",uvm_component parent);
            super.new(name, parent);
`uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)

    endfunction //new()

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tb = soc_tb::type_id::create("tb",this);

uvm_config_int::set(this,"tb.wbenv.master_agent","is_active",UVM_ACTIVE);  //wb master
uvm_config_int::set(this,"tb.wbenv.slave_agent","is_active",UVM_PASSIVE);   //wb slave 

 uvm_config_wrapper::set(this, "tb.wbenv.master_agent.sequencer.run_phase","default_sequence", uart_configAndRead_5::get_type()); //wb seq
    // uvm_config_wrapper::set(this,"tb.uartenv.tx_agent.seqr.run_phase", "default_sequence", uart_2_seq::get_type());
uvm_config_wrapper::set(this, "tb.spi_env.slave_agent.seqr.run_phase",  "default_sequence", read_seq::get_type()); 

   uvm_config_wrapper::set(this, "*clk_rst*", "default_sequence", clk10_rst5_seq::get_type());

    `uvm_info(get_type_name(), "Inside Build phase", UVM_HIGH)

uvm_config_int::set( this, "*", "recording_detail",1);

    endfunction  

function void check_phase(uvm_phase phase);
check_config_usage();
endfunction


function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
endfunction
task run_phase(uvm_phase phase );
uvm_objection obj = phase.get_objection();
obj.set_drain_time(this, 200ns);


endtask

endclass //base_test extends superClass