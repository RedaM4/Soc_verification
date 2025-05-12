interface wb_if (input bit clk, input bit rst_n);
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import wb_pkg::*;

//signals
bit inta;
bit cyc ;
bit stb;
bit [31:0] addr;
bit we;  //write enable 
bit [7:0] din;
bit [7:0] dout; 
bit ack;
bit valid_sb; // to till the scoreboard  wither the transaction is dummy or real  
bit rest_rf;


task  send_to_dut (wb_transaction tr);
 
if (tr.op_type == wb_write)begin
@(negedge clk);
cyc <= 1;
stb <= 1;
addr <= tr.addr;
we <= 1;
din <= tr.din;
wait(ack);
wait(!ack);
cyc <= 0;
stb <= 0;
addr <= 0;
we <= 0;
din <= 0;
valid_sb <=tr.valid_sb;
rest_rf <=tr.rest_rf;
end else if (tr.op_type == wb_read)begin

@(negedge clk);
cyc <= 1;
stb <= 1;
addr <= tr.addr;
we <= 0;
valid_sb <=tr.valid_sb;
rest_rf <=tr.rest_rf;
@(posedge clk);

wait(ack);
tr.dout = dout;
wait(!ack);
cyc <= 0;
stb <= 0;
addr <= 0;
end

endtask :send_to_dut


task  responsd_to_master ();
`uvm_info("SLAVE_DRV","\n\n⭐⭐⭐ wating for cyc & stb \n\n",UVM_DEBUG);

wait(cyc && stb);



if (we)begin
@(posedge clk);
$display("\n\n⭐slave drv reciving din:%0h at add:%0d at %0t ns\n\n" , din , addr, $time);
@(posedge clk);
ack <=1;
@(posedge clk);
ack <=0;

end else if (!we)begin
@(posedge clk);
dout= $random(); 
$display("\n\n⭐ slave drv sending dout:0x%0h at %0t ns\n\n" , dout , $time);
@(posedge clk);
ack <=1;
@(posedge clk);
ack <=0;
end






endtask :responsd_to_master



endinterface : wb_if

