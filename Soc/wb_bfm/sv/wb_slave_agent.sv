class wb_slave_agent extends uvm_agent;

  // This field determines whether an agent is active or passive.
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  // slave's id
  int slave_id;

  wb_slave_monitor   monitor;
  wb_slave_driver    driver;
  wb_slave_sequencer sequencer;
  

  `uvm_component_utils_begin(wb_slave_agent)

    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_field_int(slave_id, UVM_ALL_ON)
  `uvm_component_utils_end

  //constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
      monitor = wb_slave_monitor::type_id::create("monitor", this);
    if(is_active == UVM_ACTIVE) begin
      sequencer = wb_slave_sequencer::type_id::create("sequencer", this);
      driver = wb_slave_driver::type_id::create("driver", this);
    end
  endfunction : build_phase

   
  // connect_phase
  virtual function void connect_phase(uvm_phase phase);
    if(is_active == UVM_ACTIVE) begin
      // Binds the driver to the sequencer using consumer-producer interface
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase




  // assign the id of the agent's children
  function void set_slave_id(int i);
      monitor.slave_id =i;
    if (is_active == UVM_ACTIVE) begin
      sequencer.slave_id = i;
      driver.slave_id = i;
    end
  endfunction


endclass : wb_slave_agent


