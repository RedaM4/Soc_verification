class soc_ref_model extends uvm_component;
  `uvm_component_utils(soc_ref_model)

// uvm_analysis_port #(yapp_packet) yapp_valid_port;


//   `uvm_analysis_imp_decl(_hbus)
  `uvm_analysis_imp_decl(_uart)
  uvm_analysis_imp_yapp#(yapp_packet, router_reference) uart_in; // need to fix

//   uvm_analysis_imp_hbus#(hbus_transaction, router_reference) hbus_in;



  function new(string name = "soc_ref_model", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Inside Constructor!", UVM_HIGH)
    
    uart_in = new("uart_in", this);
    // hbus_in = new("hbus_in", this);
    // yapp_valid_port = new("yapp_valid_port", this);
  endfunction


function void write_uart(hbus_transaction tr);   // type need to be fixed


//*********
// some mapping logic for uart
//*********

endfunction: write_uart


endclass