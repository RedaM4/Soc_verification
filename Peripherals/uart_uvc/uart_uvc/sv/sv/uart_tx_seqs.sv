// class uart_tx_seqs extends uvm_sequence #(uart_packet);
  
//   // Required macro for sequences automation
//   `uvm_object_utils(uart_tx_seqs)

//   // Constructor
//   function new(string name="uart_tx_seqs");
//     super.new(name);
//      `uvm_info(get_type_name(), "Executing sequence", UVM_LOW)

//   endfunction

//   task pre_body();
//     uvm_phase phase;
//     `ifdef UVM_VERSION_1_2
//       // in UVM1.2, get starting phase from method
//       phase = get_starting_phase();
//     `else
//       phase = starting_phase;
//     `endif
//     if (phase != null) begin
//       phase.raise_objection(this, get_type_name());
//       `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
//     end
//   endtask : pre_body

//   task post_body();
//     uvm_phase phase;
//     `ifdef UVM_VERSION_1_2
//       // in UVM1.2, get starting phase from method
//       phase = get_starting_phase();
//     `else
//       phase = starting_phase;
//     `endif
//     if (phase != null) begin
//       phase.drop_objection(this, get_type_name());
//       `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
//     end
//   endtask : post_body

// endclass : uart_tx_seqs


// class uart_2_seq extends uvm_sequence #(uart_packet);
//     `uvm_object_utils(uart_2_seq)

//     function new(string name = "uart_2_seq");
//         super.new(name);
//     endfunction

//     task body();
//         `uvm_info(get_type_name(), "Executing uart_1_seq sequence", UVM_LOW)
//         repeat (10) begin
//             uart_packet pkt = uart_packet::type_id::create("pkt");
//             start_item(pkt);
//             assert(pkt.randomize());
//             finish_item(pkt);
//             `uvm_info(get_type_name(), $sformatf("Packet sent:\n%s", pkt.sprint()), UVM_HIGH)
//         end
//         `uvm_info(get_type_name(), "Sequence completed", UVM_HIGH)
//     endtask
// endclass

// class uart_1_seq extends uart_tx_seqs;
//     `uvm_object_utils(uart_1_seq)

//     // Constructor
//     function new(string name = "uart_1_seq");
//         super.new(name);
//     endfunction

//     // Body task
//     task body();
//         `uvm_info(get_type_name(), "Executing uart_1_seq sequence", UVM_LOW)
//         repeat(10) begin
//         `uvm_create(req)        
//         req.data = 8'hFF;       
//         req.parity_mode = 0;    
//         req.baud_rate = 9600;   
//         `uvm_send(req)
//         end
//         `uvm_info(get_type_name(), $sformatf("Packet sent:\n%s", req.sprint()), UVM_HIGH)
//     endtask
// endclass


class uart_1_seq extends uvm_sequence #(uart_packet);
    `uvm_object_utils(uart_1_seq)

    // Constructor
    function new(string name = "uart_1_seq");
        super.new(name);
        `uvm_info(get_type_name(), "Executing uart_1_seq sequence", UVM_LOW)

    endfunction

    // Body task
    task body();
        `uvm_info(get_type_name(), "Executing uart_1_seq sequence", UVM_LOW)
        repeat(10) begin
            `uvm_create(req)
            req.data = 8'hFF;       // Example data
            req.parity_mode = 0;    // Example parity mode
            req.baud_rate = 9600;   // Example baud rate

            `uvm_send(req)
            `uvm_info(get_type_name(), $sformatf("Packet sent:\n%s", req.sprint()), UVM_HIGH)
        end
        `uvm_info(get_type_name(), "Sequence completed", UVM_HIGH)
    endtask


    // function print();
    //   $display("\n-------------------------here at seq----------------------\n");
      
    // endfunction
endclass



