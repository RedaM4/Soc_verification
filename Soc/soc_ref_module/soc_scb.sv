class soc_scb extends uvm_scoreboard;
 `uvm_component_utils(router_scb)

 function new(string name = "uart_ver_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)
    
    uart_tx_imp = new("uart_tx_imp", this);
    uart_rx_imp = new("uart_rx_imp", this);
    wb_in_imp   = new("wb_in_imp", this);
    wb_out_imp  = new("wb_out_imp", this);

  endfunction: new


//**********************
//   Start OF UART SCB
//**********************    `uvm_analysis_imp_decl(_uart_tx)
    `uvm_analysis_imp_decl(_uart_rx)
    `uvm_analysis_imp_decl(_wb_out)
    `uvm_analysis_imp_decl(_wb_in)


  uvm_analysis_imp_uart_tx #(uart_packet, uart_ver_scoreboard) uart_tx_imp;
    uvm_analysis_imp_uart_rx #(uart_packet, uart_ver_scoreboard) uart_rx_imp;
    uvm_analysis_imp_wb_in   #(n_cpu_transaction, uart_ver_scoreboard) wb_in_imp;
    uvm_analysis_imp_wb_out  #(n_cpu_transaction, uart_ver_scoreboard) wb_out_imp;


    uart_packet uart_q[$];
    n_cpu_transaction wb_q[$];

    int num_mismatched = 0;
    int num_matched = 0;

 function void write_uart_rx(uart_packet packet);
 uart_q.push_back(packet);
  endfunction


   function void write_wb_in(n_cpu_transaction packet);
 wb_q.push_back(packet);
  endfunction
  function void write_uart_tx(uart_packet uart_packet);
 n_cpu_transaction wb_packet ;

      if (wb_q.size() > 0) begin
  wb_q.pop_front(wb_packet);end

 if (comp_equal(wb_packet.data,uart_packet.data )) begin
        num_matched++;
      end else begin
        num_mismatched++;
      end
 
  endfunction



     function void write_wb_out(n_cpu_transaction wb_packet);
     uart_packet uart_pkt;
      if (uart_q.size() > 0) begin
  uart_q.pop_front(uart_pkt);end

 if (comp_equal(uart_pkt.data,wb_packet.data )) begin
        num_matched++;
      end else begin
        num_mismatched++;
      end

  endfunction

//**********************
//   END OF UART SCB
//**********************



function void report_phase(uvm_phase phase);
  super.report_phase(phase);
  
  `uvm_info("UART_SCB", $sformatf("Number of matched transactions    : %0d", num_matched), UVM_LOW)
  `uvm_info("UART_SCB", $sformatf("Number of mismatched transactions : %0d", num_mismatched), UVM_LOW)

endfunction


endclass