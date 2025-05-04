//requires craaaazy revision


class wb_slave_driver extends uvm_driver #(n_cpu_transaction);

`uvm_component_utils(wb_slave_driver);

n_cpu_transaction item;

virtual interface wb_if vif;

//logic [31:0] data_read = 32'haaaaaaaa;

int UART_RANGE_LOW  = 32;
int UART_RANGE_HIGH = 63;


function new(string name="wb_slave_driver", uvm_component parent);
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
      reset_signals();
    join
  endtask : run_phase

  task drive();
    //@(posedge vif.reset);
    @(negedge vif.reset);
    `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
    forever 
        begin
          if(vif.STB_O && vif.CYC_O)
            begin
                if(vif.ADR_O>UART_RANGE_LOW && vif.ADR_O<UART_RANGE_HIGH)
                    begin
                        if(vif.WE_O==0)
                            begin
                                repeat(3) begin
                                  @(negedge vif.clock);
                                vif.ACK_I<=1'b1;
                                end
                            end
                        else if(vif.WE_O==1)
                            begin
  //                              data_read<=vif.DAT_O;
                                repeat(3) begin
                                  @(negedge vif.clock);
                                vif.ACK_I<=1'b1;
                                end
                            end
                    end
            end
        end


  endtask : drive

  // Reset all TX signals
  task reset_signals();
    forever 
     vif.wb_reset();
  endtask : reset_signals

endclass: wb_slave_driver
