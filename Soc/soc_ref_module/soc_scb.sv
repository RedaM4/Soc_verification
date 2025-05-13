class soc_scb extends uvm_scoreboard;
 `uvm_component_utils(soc_scb)
  // uvm_analysis_port#(wb_transaction) scb_port;

    `uvm_analysis_imp_decl(_wb)
    uvm_analysis_imp_wb#(wb_transaction, soc_scb) wb_in;
    
    `uvm_analysis_imp_decl(_spi1)
    uvm_analysis_imp_spi1#(spi_transaction, soc_scb) spi_in1;


 function new(string name = "soc_scb", uvm_component parent);
    super.new(name, parent);
    `uvm_info("SCB_CLASS", "Inside Constructor!", UVM_HIGH)
    // //UART
    // uart_tx_imp = new("uart_tx_imp", this);
    // uart_rx_imp = new("uart_rx_imp", this);
    wb_in   = new("wb_in", this);
    // wb_out_imp  = new("wb_out_imp", this);

//SPI
  spi_in1 = new("spi_in1", this);
    // spi_in2 = new("spi_in2", this);
    // ref_in  = new("ref_in", this);



  endfunction: new


//**********************
//   Start OF UART SCB
//**********************    `uvm_analysis_imp_decl(_uart_tx)
//     `uvm_analysis_imp_decl(_uart_rx)
//     `uvm_analysis_imp_decl(_wb_out)
//     `uvm_analysis_imp_decl(_wb_in)


//   uvm_analysis_imp_uart_tx #(uart_packet, uart_ver_scoreboard) uart_tx_imp;
//     uvm_analysis_imp_uart_rx #(uart_packet, uart_ver_scoreboard) uart_rx_imp;
//     uvm_analysis_imp_wb_in   #(n_cpu_transaction, uart_ver_scoreboard) wb_in_imp;
//     uvm_analysis_imp_wb_out  #(n_cpu_transaction, uart_ver_scoreboard) wb_out_imp;


//     uart_packet uart_q[$];
//     n_cpu_transaction wb_q[$];

//     int num_mismatched = 0;
//     int num_matched = 0;

//  function void write_uart_rx(uart_packet packet);
//  uart_q.push_back(packet);
//   endfunction


//    function void write_wb_in(n_cpu_transaction packet);
//  wb_q.push_back(packet);
//   endfunction
//   function void write_uart_tx(uart_packet uart_packet);
//  n_cpu_transaction wb_packet ;

//       if (wb_q.size() > 0) begin
//   wb_q.pop_front(wb_packet);end

//  if (comp_equal(wb_packet.data,uart_packet.data )) begin
//         num_matched++;
//       end else begin
//         num_mismatched++;
//       end
 
//   endfunction



//      function void write_wb_out(n_cpu_transaction wb_packet);
//      uart_packet uart_pkt;
//       if (uart_q.size() > 0) begin
//   uart_q.pop_front(uart_pkt);end

//  if (comp_equal(uart_pkt.data,wb_packet.data )) begin
//         num_matched++;
//       end else begin
//         num_mismatched++;
//       end

//   endfunction

//**********************
//   END OF UART SCB
//**********************

//******************************************************************************
//   START OF SPI_1 SCB
//**********************

 // Analysis ports
  // `uvm_analysis_imp_decl(_spi1)
  // uvm_analysis_imp_spi1#(spi_transaction, scoreboard) spi_in1;

  // `uvm_analysis_imp_decl(_spi2)
  // uvm_analysis_imp_spi2#(spi_transaction, scoreboard) spi_in2;

  // `uvm_analysis_imp_decl(_spi1ref)
  // uvm_analysis_imp_spi1ref#(wb_transaction, scoreboard) ref_in;

  // Stats
  int total_packets_received = 0;
  int total_matched_packets  = 0;
  int total_wrong_packets    = 0;
  int total_spi_transactions = 0;
  int total_ref_transactions = 0;

  // Reference model instance 
  wb_x_spi_module ref_model;


  // SPI 1 callback
  function void write_spi1(spi_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received SPI1 Transaction: %s", t.sprint()), UVM_MEDIUM)
    // ref_model.tx_queue.push_back(t.data_in);
    ref_model.rx_queue.push_back(t.data_out);
    ref_model.spi_queue.push_back(t);
    total_spi_transactions++;
    total_packets_received++;
    compare_transactions();
  endfunction


  // Reference Model callback
  function void write_wb(wb_transaction t);
    `uvm_info("SCOREBOARD", $sformatf("Received REF Transaction: %s", t.sprint()), UVM_MEDIUM)
     if(t.addr ==2) begin
    ref_model.tx_queue.push_back(t.din);
    ref_model.rx_queue.push_back(t.dout);
     end
    ref_model.wb_queue.push_back(t);
    total_ref_transactions++;
    total_packets_received++;
    compare_transactions();
  endfunction


function void compare_transactions();
  if (ref_model.wb_queue.size() == 0)
    return;

  else begin
  wb_transaction ref_pkt = ref_model.wb_queue.pop_front();
   if (ref_pkt.op_type == wb_read) begin
  // Only expect SPI data for SPDR register 
    case (ref_pkt.addr)
      32'h0: compare_reg("SPCR", ref_pkt.dout, ref_model.get_SPCR());
      32'h1: compare_reg("SPSR", ref_pkt.dout, ref_model.get_SPSR());
       32'h2: begin // SPDR
            if (ref_model.spi_queue.size() > 0 &&
            ref_model.rx_queue.size() > 0 &&
            ref_model.tx_queue.size() > 0) begin
            bit [7:0] expected_data = ref_model.rx_queue.pop_front();
            bit [7:0] actual_data   = ref_model.tx_queue.pop_front();
            spi_transaction spi_pkt = ref_model.spi_queue.pop_front();
            if (spi_pkt.data_out == ref_model.get_SPDR()) begin
              total_matched_packets++;
              `uvm_info("SCOREBOARD", $sformatf("MATCH: WB read = %h, expected SPI = %h",  ref_model.get_SPDR(),spi_pkt.data_out), UVM_HIGH)
            end else begin
              total_wrong_packets++;
              `uvm_error("SCOREBOARD", $sformatf("MISMATCH: WB read = %h, expected SPI = %h", ref_model.get_SPDR(), spi_pkt.data_out))
            end
            end
            end 
      32'h3: compare_reg("SPER", ref_pkt.dout, ref_model.get_SPER());
      32'h4: compare_reg("CSREG", ref_pkt.dout, ref_model.get_CSREG());
     default: begin 
        `uvm_warning("SCOREBOARD", "Unhandled address in comparison");
         end 
    endcase
   
  end 
  
  end 
endfunction


function void compare_reg(string name, bit [7:0] actual, bit [7:0] expected);
    void'(ref_model.rx_queue.pop_front());
      void'(ref_model.tx_queue.pop_front());
  if (actual == expected) begin
    total_matched_packets++;
    `uvm_info("SCOREBOARD", $sformatf("MATCH: WB = %h, REF_MODEL %s = %h", actual, name, expected), UVM_HIGH)
  end else begin
    total_wrong_packets++;
    `uvm_error("SCOREBOARD", $sformatf("MISMATCH: WB = %h, REF_MODEL %s = %h", actual, name, expected))
  end
endfunction




//**********************
//   END OF SPI_1 SCB
//**********************



function void report_phase(uvm_phase phase);
  super.report_phase(phase);
  //UART
  // `uvm_info("UART_SCB", $sformatf("Number of matched transactions    : %0d", num_matched), UVM_LOW)
  // `uvm_info("UART_SCB", $sformatf("Number of mismatched transactions : %0d", num_mismatched), UVM_LOW)


//SPI_1
    `uvm_info("SCOREBOARD", "--------------------SPI_1 SCOREBOARD REPORT --------------------", UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total SPI Transactions  : %0d", total_spi_transactions), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total REF Transactions  : %0d", total_ref_transactions), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Received Packets  : %0d", total_packets_received), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Matched Packets   : %0d", total_matched_packets), UVM_LOW)
    `uvm_info("SCOREBOARD", $sformatf("Total Wrong Packets     : %0d", total_wrong_packets), UVM_LOW)
  


endfunction


endclass