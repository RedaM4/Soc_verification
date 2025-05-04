//needs craaaazy revision


class wb_master_driver extends uvm_driver #(n_cpu_transaction);

`uvm_component_utils(wb_master_driver);

n_cpu_transaction item;

virtual interface wb_if vif;

//logic [7:0] data_read;

function new(string name="wb_master_driver", uvm_component parent);
super.new(name,parent);
`uvm_info("--DRIVER_CLASS--","INSIDE CONSTRUCTOR",UVM_HIGH);
endfunction

function void start_of_simulation_phase(uvm_phase phase);
super.start_of_simulation_phase(phase);

`uvm_info("--DRIVER_CLASS--","START OF SIMULATION PHASE",UVM_HIGH);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
`uvm_info("--DRIVER_CLASS--","INSIDE BUILD PHASE",UVM_HIGH);
item = n_cpu_transaction::type_id::create("item");

if(!(wb_vif_config::get(this,"","vif",vif)))begin
`uvm_error("DRIVER CLASS", "Failed to get vif from config db");
end
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
`uvm_info("--DRIVER_CLASS--","INSIDE CONNECT PHASE",UVM_HIGH);
endfunction


task run_phase(uvm_phase phase);
`uvm_info("--DRIVER_CLASS--","INSIDE RUN PHASE",UVM_HIGH);


    fork
      drive();
     vif.wb_reset();
    join

  endtask : run_phase

  task drive();
    //@(posedge vif.reset);
    @(negedge vif.reset);
    `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
    forever begin
      seq_item_port.get_next_item(req);

      `uvm_info(get_type_name(), $sformatf("sending these information :\n%s", req.sprint()), UVM_HIGH)
       
        begin
          vif.send_to_dut(req.address, req.data);
          vif.STB_O<=1;
          vif.CYC_O<=1;

          if(req.M_STATE==WRITE)
            vif.WE_O<= 1'b1;
          else if(req.M_STATE==READ)
            vif.WE_O<= 1'b0;
          else
            `uvm_error("--INTERFACE--", "WB INTERFACE RECIEVED NULL MASTER STATE");
        end

        wait(vif.ACK_I)
          begin
            vif.STB_O<=1'b0;
            vif.CYC_O<=1'b0;
            vif.ACK_I<=1'b0;
            seq_item_port.item_done;
          end

    end
  endtask : drive

 
  // UVM report_phase
  //function void report_phase(uvm_phase phase);
  //  `uvm_info(get_type_name(), $sformatf("Report: MASTER driver sent ADDRESS and DATA on ", num_sent), UVM_LOW)
  //endfunction : report_phase


//*/
endclass: wb_master_driver
