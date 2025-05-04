class uart_tb extends uvm_env;
    `uvm_component_utils(uart_tb)

    uart_env env;

    // Constructor
    function new(string name = "uart_tb", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("TB_TEST", "Inside Constructor!", UVM_HIGH)
    endfunction: new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TB_TEST", "Build Phase!", UVM_HIGH)
        
        env = uart_env::type_id::create("env", this);

    endfunction: build_phase

    // Start of simulation phase
    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info("TB_TEST", "Start of simulation phase", UVM_HIGH)
    endfunction



    // Connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_type_name(), "Connect Phase!", UVM_HIGH)
    endfunction: connect_phase
endclass: uart_tb