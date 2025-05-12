
class wb_slave_driver extends uvm_driver #(wb_transaction);

  virtual wb_if vif;

  // slave Id
  int slave_id;


  `uvm_component_utils_begin(wb_slave_driver)
    `uvm_field_int(slave_id, UVM_DEFAULT)
  `uvm_component_utils_end

  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!wb_vif_config::get(this, get_full_name(),"vif", vif))
      `uvm_error(get_type_name(),{"virtual interface must be set for: ",get_full_name(),".vif"})
  endfunction: build_phase



  // run_phase
  virtual task run_phase(uvm_phase phase);
      @(negedge vif.clk);

    forever begin
      // Get new item from the sequencer
    //  seq_item_port.get_next_item(req);
      @(negedge vif.clk);
   // `uvm_info(get_type_name(), req.sprint() ,UVM_MEDIUM)
      vif.responsd_to_master();
    //  seq_item_port.item_done();
    end

    
  endtask : run_phase

endclass : wb_slave_driver


