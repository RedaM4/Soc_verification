// csr_file.sv
// This module implements a machine-mode CSR file for a RISC-V core supporting
// the Zicsr extension. It includes the minimal mandatory CSRs plus timer registers.
// The design supports two update paths:
//   1. CSR writes via the core interface.
//   2. External trap event updates (for exceptions/interrupts) which update mstatus,
//      mepc, mcause, and mtval per the spec. In a trap event, mstatus is updated from an
//      external input (mstatus_in) so that all status bits are properly set (e.g. MPIE, MIE, MPP).
// Additionally, the module outputs a trap signal and trap vector (mtvec) for the external PC jump.

module csr_file (
    input  logic         clk,
    input  logic         reset_n,

    // CSR interface (Zicsr extension)
    input  logic         csr_en,         // Asserted when a CSR access is performed
    input  logic [1:0]   csr_cmd,        // CSR command: 00=csrrw, 01=csrrs, 10=csrrc
    input  logic [11:0]  csr_addr,       // 12-bit CSR address from the core
    input  logic [31:0]  csr_wdata,      // Data for CSR writes (or immediate value)
    output logic [31:0]  csr_rdata,      // CSR read data output

    input  logic [31:0]  cinst_pc,      // Current instruction PC
    input  logic [31:0]  ninst_pc,      // Next instruction PC
    input  logic         exception_i,   // Synchronous exception detected
    input  logic [5:0]   e_code,        // Encoded exception cause

    // Interrupt signals (from hardware or an interrupt controller)
    input  logic         timer_irq,     // Timer interrupt pending
    input  logic         external_irq,  // External interrupt pending

    // To the pipeline controller and the next pc logic
    output logic         trap,          // Asserted when a trap is taken
    output logic [31:0]  mtvec,          // Trap handler base address (mtvec)
    output logic [31:0]  mepc,
    output logic [5:0]   trap_cause,
    input  logic         trap_ret,

    input logic dont_trap
);


    // CSR ADDRESS MAP (FROM RISCV SPEC)
    localparam ADDR_MSTATUS  = 12'h300;
    localparam ADDR_MIE      = 12'h304;
    localparam ADDR_MTVEC    = 12'h305;
    localparam ADDR_MSCRATCH = 12'h340;
    localparam ADDR_MEPC     = 12'h341;
    localparam ADDR_MCAUSE   = 12'h342;
    localparam ADDR_MTVAL    = 12'h343; // not implemented as of now
    localparam ADDR_MIP      = 12'h344;

    localparam MTVEC_WR_MASK    = 32'hFFFFFFFD;
    localparam MSTATUS_WR_MASK  = 32'h00000088;
    localparam MIP_WR_MASK      = 32'hFFFFFFFD;
    localparam MIE_WR_MASK      = 32'h00000880;
    localparam MSCRATCH_WR_MASK = 32'hFFFFFFFF;
    localparam MCAUSE_WR_MASK   = 32'h9000003F;
    localparam MTVAL_WR_MASK    = 32'hFFFFFFFF;
    localparam MEPC_WR_MASK     = 32'hFFFFFFFC; // word aligned 


    // RESET VALUES OF THE REGISTERS
    localparam MSTATUS_RESET_VALUE = 32'h0; // disable interrtups at reset


    //--------------------------------------------------------------------------
    // Internal Registers for Machine-Mode CSRs (32-bit)
    // Note: Some registers are updated by CSR writes; others are updated on trap events.
    //--------------------------------------------------------------------------
    logic [31:0] mstatus_reg;
    logic [31:0] mie_reg;
    logic [31:0] mtvec_reg;
    logic [31:0] mepc_reg;
    logic [31:0] mcause_reg;
    logic [31:0] mtval_reg;
    logic [31:0] mscratch_reg;
    logic [31:0] mip_reg;



    // =================================================================== //
    //                            MSTATUS REGISTER                         //
    // =================================================================== //
    always_ff @(posedge clk, negedge reset_n) begin 
        if(~reset_n) mstatus_reg <= MSTATUS_RESET_VALUE;
        else begin 
            if(csr_addr == ADDR_MSTATUS & csr_en) begin 
                if (csr_cmd == 2'b01)
                    mstatus_reg <= (csr_wdata & MSTATUS_WR_MASK);
                else if (csr_cmd == 2'b10)
                    mstatus_reg <= mstatus_reg | (csr_wdata & MSTATUS_WR_MASK);
                else if (csr_cmd == 2'b11)
                    mstatus_reg <= mstatus_reg & ~ (csr_wdata & MSTATUS_WR_MASK);
            end else if(trap) begin 
                mstatus_reg[7] <= mstatus_reg[3]; 
                mstatus_reg[3] <= 1'b0;           // disable interrupts
            end else if(trap_ret) begin 
                mstatus_reg[3] <= mstatus_reg[7]; 
                mstatus_reg[7] <= 1'b1;   // previous interrupt enable to 1, doesnot matter
            end
        end
    end


    // =================================================================== //
    //                               MIE REGITER                           //
    // =================================================================== //
    always_ff @(posedge clk, negedge reset_n) begin 
        if(~reset_n) mie_reg <= 'b0;
        else begin 
            if(csr_addr == ADDR_MIE & csr_en) begin 
                if (csr_cmd == 2'b01)
                    mie_reg <= (csr_wdata & MIE_WR_MASK);
                else if (csr_cmd == 2'b10)
                    mie_reg <= mie_reg | (csr_wdata & MIE_WR_MASK);
                else if (csr_cmd == 2'b11)
                    mie_reg <= mie_reg & ~(csr_wdata & MIE_WR_MASK);
            end 
        end
    end


    // =================================================================== //
    //                              MTVEC REGITER                          //
    // =================================================================== //
    always_ff @(posedge clk, negedge reset_n) begin 
        if(~reset_n) mtvec_reg <= 'b0;
        else begin 
            if(csr_addr == ADDR_MTVEC & csr_en) begin 
                if (csr_cmd == 2'b01)
                    mtvec_reg <= (csr_wdata & MTVEC_WR_MASK);
                else if (csr_cmd == 2'b10)
                    mtvec_reg <= mtvec_reg | (csr_wdata & MTVEC_WR_MASK);
                else if (csr_cmd == 2'b11)
                    mtvec_reg <= mtvec_reg & ~ (csr_wdata & MTVEC_WR_MASK);
            end 
        end
    end


    // =================================================================== //
    //                            MSCRATCH REGITER                         //
    // =================================================================== //
    always_ff @(posedge clk, negedge reset_n) begin 
        if(~reset_n) mscratch_reg <= 'b0;
        else begin 
            if(csr_addr == ADDR_MSCRATCH & csr_en) begin 
                if (csr_cmd == 2'b01)
                    mscratch_reg <= (csr_wdata & MSCRATCH_WR_MASK);
                else if (csr_cmd == 2'b10)
                    mscratch_reg <= mscratch_reg | (csr_wdata & MSCRATCH_WR_MASK);
                else if (csr_cmd == 2'b11)
                    mscratch_reg <= mscratch_reg & ~(csr_wdata & MSCRATCH_WR_MASK);
            end 
        end
    end


    // =================================================================== //
    //                             MTVAL REGITER                           //
    // =================================================================== //
    always_ff @(posedge clk, negedge reset_n) begin 
        if(~reset_n) mtval_reg <= 'b0;
        else begin 
            if(csr_addr == ADDR_MSCRATCH & csr_en) begin 
                if (csr_cmd == 2'b01)
                    mtval_reg <= (csr_wdata & MTVAL_WR_MASK);
                else if (csr_cmd == 2'b10)
                    mtval_reg <= mtval_reg | (csr_wdata & MTVAL_WR_MASK);
                else if (csr_cmd == 2'b11)
                    mtval_reg <= mtval_reg & ~(csr_wdata & MTVAL_WR_MASK);
            end else if (trap) begin 
                    mtval_reg <= 32'b11; // as of now always set this on trap (need to modify according to size of current inst 
                    // as will be needed for ecall handler, load/store address fault handlers)
            end
        end
    end


    // =================================================================== //
    //                MACHINE INTERRUPT PENDING (MIP) REGITER              //
    // =================================================================== //
    // always_ff @(posedge clk, negedge reset_n) begin 
    //     if(~reset_n) mip_reg <= 'b0;
    //     else begin 
    //             if(timer_irq  )   mip_reg[7]  <= 1'b1;
    //             if(external_irq)  mip_reg[11] <= 1'b1;
    //     end
    // end
    assign mip_reg[7] = timer_irq;
    assign mip_reg[11] = external_irq;
    assign mip_reg[6:0] = 0;
    assign mip_reg[31:12] = 0;



    // =================================================================== //
    //                             MCAUSE REGITER                          //
    // =================================================================== //
    // logic [5:0] trap_cause;
    logic exception;
    always_ff @(posedge clk, negedge reset_n) begin 
        if(~reset_n) mcause_reg <= 'b0;
        else begin 
            if(csr_addr == ADDR_MCAUSE & csr_en) begin 
                if (csr_cmd == 2'b01)
                    mcause_reg <= csr_wdata;
                else if (csr_cmd == 2'b10)
                    mcause_reg <= mcause_reg | csr_wdata;
                else if (csr_cmd == 2'b11)
                    mcause_reg <= mcause_reg & ~csr_wdata;
            end else begin 
                if(trap)   mcause_reg <= (~exception_i << 31 | (trap_cause));
            end 
        end
    end


    // =================================================================== //
    //                              MEPC REGITER                           //
    // =================================================================== //
    always_ff @(posedge clk, negedge reset_n) begin 
        if(~reset_n) mepc_reg <= 'b0;
        else begin 
            if(csr_addr == ADDR_MEPC & csr_en) begin 
                if (csr_cmd == 2'b01)
                    mepc_reg <= csr_wdata;
                else if (csr_cmd == 2'b10)
                    mepc_reg <= mepc_reg | csr_wdata;
                else if (csr_cmd == 2'b11)
                    mepc_reg <= mepc_reg & ~csr_wdata;
            end else begin 
                if(trap)   mepc_reg <= cinst_pc;
            end 
        end
    end




    // =================================================================== //
    //                              TRAP LOGIC                             //
    // =================================================================== //

    logic mei;  // global interrupt enable
    logic mtip; // timer interrupt pending
    logic meip; // exception pending
    logic mtie; // timer interrupt enable
    logic meie; // exception enable

    assign mei  = mstatus_reg[3];
    assign mtip = mip_reg[7];
    assign mtie = mie_reg[7];
    assign meip = mip_reg[11];
    assign meie = mie_reg[11];


    assign trap        = ((mei & ((mtie & mtip) | (meie & meip) )) | exception_i ) & ~dont_trap;
    assign trap_cause  = (exception_i) ? e_code : 
                         (meip) ? 6'd11:
                         6'd7; // for the timer interrupt 





    // =================================================================== //
    //                        OUTPUTS & CSR READ LOGIC                     //
    // =================================================================== //
   
    assign mepc = mepc_reg;
    assign mtvec = mtvec_reg;

    always_comb begin
        case (csr_addr)
            ADDR_MSTATUS:  csr_rdata = mstatus_reg;
            ADDR_MIE:      csr_rdata = mie_reg;
            ADDR_MTVEC:    csr_rdata = mtvec_reg;
            ADDR_MSCRATCH: csr_rdata = mscratch_reg;
            ADDR_MEPC:     csr_rdata = mepc_reg;
            ADDR_MCAUSE:   csr_rdata = mcause_reg;
            ADDR_MTVAL:    csr_rdata = mtval_reg;
            ADDR_MIP:      csr_rdata = mip_reg; // plus any hardware-combined bits
            default:       csr_rdata = 32'h0;
        endcase
    end

endmodule
