class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    uart_tb tb; 

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("BASE_TEST", "\n\nNew phase ", UVM_HIGH)
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BASE_TEST", "\nBuild phase started", UVM_HIGH)

        tb = uart_tb::type_id::create("tb", this);
        `uvm_info("BASE_TEST", "\nEnvironment created", UVM_HIGH)

        uvm_config_wrapper::set(this,"tb.env.rx_agent.seqr.run_phase", "default_sequence", uart_1_seq::get_type());
        uvm_config_wrapper::set(this, "tb.env.tx_agent.seqr.run_phase", "default_sequence", uart_1_seq::get_type());

        `uvm_info("BASE_TEST", "\nDefault sequence configured", UVM_HIGH)
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("BASE_TEST", "\nStarting sequence", UVM_MEDIUM)
    endtask

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("BASE_TEST", "End of elaboration phase", UVM_HIGH)
        uvm_top.print_topology();
    endfunction
endclass

class uart_parity_test extends base_test;
    `uvm_component_utils(uart_parity_test)

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_type_name(), "\nNew phase ", UVM_HIGH)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Reuse base_test build_phase
        `uvm_info(get_type_name(), "\nBuild phase (extended) started", UVM_HIGH)
      uvm_config_wrapper::set(this,"tb.env.rx_agent.seqr.run_phase", "default_sequence", uart_parity_seqs::get_type());
        uvm_config_wrapper::set(this, "tb.env.tx_agent.seqr.run_phase", "default_sequence", uart_parity_seqs::get_type());
    endfunction
endclass

class uart_rand_dual_send_test extends base_test;
    `uvm_component_utils(uart_rand_dual_send_test)

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info(get_type_name(), "\nNew phase ", UVM_HIGH)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase); // Reuse base_test build_phase
        `uvm_info(get_type_name(), "\nBuild phase (extended) started", UVM_HIGH)
      uvm_config_wrapper::set(this,"tb.env.rx_agent.seqr.run_phase", "default_sequence", uart_rand_dual_send_seqs::get_type());
        uvm_config_wrapper::set(this, "tb.env.tx_agent.seqr.run_phase", "default_sequence", uart_rand_dual_send_seqs::get_type());
    endfunction
endclass
