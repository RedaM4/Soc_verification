
// include directories, starting with UVM src directory
-incdir ../sv

// compile files
../sv/i2c_pkg.sv
../sv/i2c_if.sv 
demo_i2c_top.sv




////// run command
// vcs -sverilog -timescale=1ns/1ns -full64 -f filelist.f -ntb_opts -uvm   -o   simv ;     ./simv -f run.f;

