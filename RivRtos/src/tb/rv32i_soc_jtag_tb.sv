
`ifndef PD_BUILD
    `ifdef tracer 
        `include "tb/pkg.sv"
        `include "tb/tracer_pkg.sv"
        `include "tb/tracer.sv"
    `endif 

    `include "tb/SimJTAG.sv" 

    module rv32i_soc_tb;
        logic clk;
        logic reset_n;
        logic o_flash_sclk;
        logic o_flash_cs_n;
        logic o_flash_mosi;
        logic i_flash_miso;
        logic o_uart_tx;
        logic i_uart_rx;
        logic pwm_pad_o;
        logic tck_i;
        logic tms_i;
        logic tdi_i;
        logic tdo_o;
        
        logic        i_scl;
        logic        o_scl;
        logic        o_scl_oen;
        logic        i_sda;
        logic        o_sda;
        logic        o_sda_oen;

        parameter DMEM_DEPTH = 17000;
        parameter IMEM_DEPTH = 35000;
        parameter NO_OF_GPIO_PINS = 24;
        
        logic [31:0] initial_imem [0:IMEM_DEPTH - 1];
        logic [31:0] initial_dmem [0:DMEM_DEPTH - 1];

        // GPIO - Leds and Switches
        wire [NO_OF_GPIO_PINS - 1:0] en_gpio;
        wire [NO_OF_GPIO_PINS - 1:0] i_gpio;
        wire [NO_OF_GPIO_PINS - 1:0] o_gpio;

        // ================================================//
        //                     DUT Instance                //
        // ================================================//

        rv32i_soc #(
            .IMEM_DEPTH(IMEM_DEPTH),
            .DMEM_DEPTH(DMEM_DEPTH),
            .NO_OF_GPIO_PINS(NO_OF_GPIO_PINS)
        )DUT(
            .*
        );

        // ================================================//
        //                       JTAG DPI                  //
        // ================================================//

        logic jtag_enable = 1'b1;
        logic jtag_init_done = 1'b1;  // Set to 1 when you want JTAG to start ticking
        logic jtag_exit_valid;
        
        SimJTAG sim_jtag_inst (
            .clock    (clk),
            .reset    (~reset_n),      // active high in SimJTAG
            .enable   (jtag_enable),
            .init_done(jtag_init_done),
            .jtag_TCK (tck_i),
            .jtag_TMS (tms_i),
            .jtag_TDI (tdi_i),
            .jtag_TRSTn(),             // leave unconnected if you don’t use TRST
            .srstn    (),              // optional system reset (usually not needed)
            .jtag_TDO_data(tdo_o),
            .jtag_TDO_driven(1'b1),    // mark TDO always valid
            .exit     ()
        );

        // ================================================//
        //                  Tracer Instance                //
        // ================================================//

        `ifdef tracer 
            tracer tracer_inst (
            .clk_i(clk),
            .rst_ni(reset_n),
            .hart_id_i(1),
            .rvfi_insn_t(DUT.rv32i_core_inst.data_path_inst.rvfi_insn),
            .rvfi_rs1_addr_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rs1_addr),
            .rvfi_rs2_addr_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rs2_addr),
            .rvfi_rs3_addr_t(),
            .rvfi_rs3_rdata_t(),
            .rvfi_mem_rmask(),
            .rvfi_mem_wmask(),
            .rvfi_rs1_rdata_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rs1_rdata),
            .rvfi_rs2_rdata_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rs2_rdata),
            .rvfi_rd_addr_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rd_addr),
            .rvfi_rd_wdata_t(DUT.rv32i_core_inst.data_path_inst.rvfi_rd_wdata),
            .rvfi_pc_rdata_t(DUT.rv32i_core_inst.data_path_inst.rvfi_pc_rdata),
            .rvfi_pc_wdata_t(DUT.rv32i_core_inst.data_path_inst.rvfi_pc_wdata),
            .rvfi_mem_addr(DUT.rv32i_core_inst.data_path_inst.rvfi_mem_addr),
            .rvfi_mem_wdata(DUT.rv32i_core_inst.data_path_inst.rvfi_mem_wdata),
            .rvfi_mem_rdata(DUT.rv32i_core_inst.data_path_inst.rvfi_mem_rdata),
            .rvfi_valid(DUT.rv32i_core_inst.data_path_inst.rvfi_valid)
            );
        `endif



        // Clock generator 
        initial clk = 0;
        always #5 clk = ~clk;

        // signal geneartion here
        initial begin 
            reset_n = 0;
            repeat(2) @(negedge clk);
            reset_n = 1; // dropping reset after two clk cycles
        end


    // initializing the instruction memory after every reset
    initial begin
            `ifdef USE_SRAM
                // $readmemh("tb/machine.hex", DUT.inst_mem_inst.tsmc_32k_inst.u0.mem_core_array);
                $readmemh("tb/inst_formatted.hex", DUT.inst_mem_inst.tsmc_32k_inst.u0.mem_core_array);
                $readmemh("tb/data_formatted.hex", DUT.data_mem_inst.tsmc_8k_inst.u0.mem_core_array);
    //$readmemh("tb/machine.hex", DUT.inst_mem_inst.memory);
            `elsif VCS_SIM
                $readmemh("tb/inst_formatted.hex", initial_imem);
                $readmemh("tb/data_formatted.hex", initial_dmem);
                force DUT.inst_mem_inst.dmem = initial_imem;
                        force DUT.data_mem_inst.dmem = initial_dmem;
                #1; 
                release DUT.inst_mem_inst.dmem;
                release DUT.data_mem_inst.dmem;          
            `else 
                $readmemh("/home/it/RivRtos/src/tb/crypto_tests/inst.hex", initial_imem);
                $readmemh("/home/it/RivRtos/src/tb/crypto_tests/data.hex", initial_dmem);
            force DUT.inst_mem_inst.dmem = initial_imem;
                    force DUT.data_mem_inst.dmem = initial_dmem;
            #1; 
            release DUT.inst_mem_inst.dmem;
            release DUT.data_mem_inst.dmem;
            `endif

        // $readmemh("/home/it/Documents/RVSOC-FreeRTOS-Kernel-DEMO/instr_formatted.hex",DUT.inst_mem_inst.dmem); // VIVADO
        // $readmemh("/home/it/Documents/RVSOC-FreeRTOS-Kernel-DEMO/data_formatted.hex",DUT.data_mem_inst.dmem); // VIVADO
    end // wait 

    initial begin 
        //    repeat(100000) @(posedge clk);
        //    for(int i = 0; i<= 14'h0fff; i = i+1) begin 
        //        $display("imem[%02d] = %8h", i, DUT.inst_mem_inst.memory[i]);
        //    end
    `ifdef tracer     
        repeat(500000) @(posedge clk);
        `else 
        repeat(5000) @(posedge clk);  
        `endif
        for(int i = 0; i < 100; i = i+1) begin 
                `ifdef USE_SRAM
                    $display("dmem[%02d] => %8h <=> %8h <= imem[%02d] ", i, DUT.data_mem_inst.tsmc_8k_inst.u0.mem_core_array[i], DUT.inst_mem_inst.tsmc_32k_inst.u0.mem_core_array[i], i);
                `else 
                    $display("dmem[%02d] => %8h <=> %8h <= imem[%02d] ", i, DUT.data_mem_inst.dmem[i], DUT.inst_mem_inst.dmem[i], i);
                `endif
        end
            for(int i = 0; i<32; i = i+1) begin 
                $display("reg_file[%02d] = %03d", i, DUT.rv32i_core_inst.data_path_inst.reg_file_inst.reg_file[i]);
            end
        // $finish;
    end
    initial begin
        `ifdef VCS_SIM    
            $dumpfile("waveform.vcd");
            $dumpvars(1, DUT.wishbone_master); 
            $dumpvars(1, DUT.rv32i_core_inst);            
            $dumpvars(1, DUT.rv32i_core_inst.u_core_dbg_fsm);

        `endif 
    //   $dumpvars(0, DUT.data_mem_inst);
    //   $dumpvars(0, DUT.inst_mem_inst);
    end


    endmodule
`endif
