class soc_ref_model extends uvm_component;
  `uvm_component_utils(soc_ref_model)

// uvm_analysis_port #(yapp_packet) yapp_valid_port;


//   `uvm_analysis_imp_decl(_hbus)
  `uvm_analysis_imp_decl(_wb)
  uvm_analysis_imp_wb#(n_cpu_transaction, soc_ref_model) wb_in; // need to fix

//   uvm_analysis_imp_hbus#(hbus_transaction, router_reference) hbus_in;



  function new(string name = "soc_ref_model", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)
    
    wb_in = new("wb_in", this);
    // hbus_in = new("hbus_in", this);
    // yapp_valid_port = new("yapp_valid_port", this);
  endfunction


function void write_wb(hbus_transaction tr);   // type need to be fixed


//*********
// some mapping logic for uart
//*********

endfunction: write_wb


endclass