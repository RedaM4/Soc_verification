
class wb_master_driver extends uvm_driver #(wb_transaction);

  virtual wb_if vif;

  // Master Id
  int master_id;


  `uvm_component_utils_begin(wb_master_driver)
    `uvm_field_int(master_id, UVM_DEFAULT)
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
    
    forever begin
      // Get new item from the sequencer
      seq_item_port.get_next_item(req);

      `uvm_info(get_type_name(), req.sprint() ,UVM_MEDIUM)
      vif.send_to_dut(req);
      seq_item_port.item_done();
      //put_response(rsp);


    end

    
  endtask : run_phase

endclass : wb_master_driver


