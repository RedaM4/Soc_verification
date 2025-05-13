module rv32i_soc_with_pad_tb;
    logic CLK_PAD;
    logic RESET_N_PAD;
    logic o_flash_sCLK_PAD;
    logic o_flash_cs_n;
    logic o_flash_mosi;
    logic i_flash_miso;
    logic o_uart_tx;
    logic i_uart_rx;
    logic pwm_pad_o;

    logic tck_i;
    logic tdi_i;
    logic tms_i;
    logic tdo_o;

    parameter DMEM_DEPTH = 2048;
    parameter IMEM_DEPTH = 16384;
    parameter NO_OF_GPIO_PINS = 24;

    logic CLK_PAD;  // external clock pad
    logic RESET_N_PAD;          // external reset (active low)
    logic O_FLASH_SCLK_PAD;     // external SPI flash serial clock
    logic O_FLASH_CS_N_PAD;     // external SPI flash chip‐select (active low)
    logic O_FLASH_MOSI_PAD;     // external SPI flash MOSI
    logic I_FLASH_MISO_PAD;     // external SPI flash MISO
    logic O_UART_TX_PAD;        // external UART TX
    logic I_UART_RX_PAD;       // external UART RX
    wire [23:0] IO_DATA_PAD;  // external GPIO pads
    logic O_PWM_PAD;


    // Dut instantiation
    top_rv32i_soc DUT(
        .*
    );


    assign tck_i = 0;
    assign tdi_i = 0;
    assign tms_i = 0;
    assign tdo_o = 0;	

    // Clock generator 
    initial CLK_PAD = 0;
    always #5 CLK_PAD = ~CLK_PAD;

    // signal geneartion here
    initial begin 
        RESET_N_PAD = 0;
        repeat(2) @(negedge CLK_PAD);
        RESET_N_PAD = 1; // dropping reset after two CLK_PAD cycles
    end


   // initializing the instruction memory after every reset
   initial begin
        `ifdef VCS_SIM
            $readmemh("tb/assembly_tests/machine.hex", DUT.u_rv32i_soc.inst_mem_inst.memory);
        `else 
            $readmemh("/home/it/Documents/RTOS/rvsoc/src/tb/assembly_tests/machine.hex", DUT.u_rv32i_soc.inst_mem_inst.dmem);
        `endif
        `ifndef VCS_SIM
            for (int i = 0; i<DMEM_DEPTH; i = i+1) 
            begin 
                force DUT.u_rv32i_soc.data_mem_inst.dmem = 0; 
            end
            #1;
            for (int i = 0; i<DMEM_DEPTH; i = i+1) 
            begin 
                release DUT.u_rv32i_soc.data_mem_inst.dmem;
            end
        `endif
    // $readmemh("/home/it/Documents/RVSOC-FreeRTOS-Kernel-DEMO/instr_formatted.hex",DUT.u_rv32i_soc.inst_mem_inst.dmem); // VIVADO
    // $readmemh("/home/it/Documents/RVSOC-FreeRTOS-Kernel-DEMO/data_formatted.hex",DUT.u_rv32i_soc.data_mem_inst.dmem); // VIVADO
   end // wait 

   initial begin 
    //    repeat(100000) @(posedge CLK_PAD);
    //    for(int i = 0; i<= 14'h0fff; i = i+1) begin 
    //        $display("imem[%02d] = %8h", i, DUT.u_rv32i_soc.inst_mem_inst.memory[i]);
    //    end
       repeat(10000) @(posedge CLK_PAD);
       for(int i = 0; i < 100; i = i+1) begin 
            `ifdef VCS_SIM
                $display("dmem[%02d] => %8h <=> %8h <= imem[%02d] ", i, DUT.u_rv32i_soc.data_mem_inst.memory[i], DUT.u_rv32i_soc.inst_mem_inst.memory[i], i);
            `else 
                $display("dmem[%02d] => %8h <=> %8h <= imem[%02d] ", i, DUT.u_rv32i_soc.data_mem_inst.dmem[i], DUT.u_rv32i_soc.inst_mem_inst.dmem[i], i);
            `endif
       end
        for(int i = 0; i<32; i = i+1) begin 
            $display("reg_file[%02d] = %03d", i, DUT.u_rv32i_soc.rv32i_core_inst.data_path_inst.reg_file_inst.reg_file[i]);
        end
       $finish;
   end
initial begin
    `ifdef VCS_SIM    
        $dumpfile("waveform.vcd");
        $dumpvars(0, DUT);
    `endif 
//   $dumpvars(0, DUT.u_rv32i_soc.data_mem_inst);
//   $dumpvars(0, DUT.u_rv32i_soc.inst_mem_inst);
end


endmodule

