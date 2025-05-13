module iadu (
    input logic clk,   
    input logic reset_n,  
    input logic [31:0] i_inst, 
    input logic [31:0] i_pc, 
    input logic [31:0] i_pc_if1,
    input logic        i_decode_busy,

    output logic [31:0] o_inst,
    output logic        o_is_comp,
    output logic        o_is_illegal,
    output logic [31:0] o_pc_corrected,
    output logic        o_hold,
    output logic        o_increment_pc_by_2,
    output logic        o_fetch_busy
);

    parameter NOP = 32'h00000013;
    logic pc_misaligned;
    logic is_comp, next_is_comp;
    logic its_a_jump;
    assign pc_misaligned = i_pc[1];

    // register to save the previous instruction    
    logic [31:0] prev_inst;
    n_bit_reg #(
        .n(32)
    ) inst_reg (
        .clk(clk),
        .reset_n(reset_n),
        .wen(~i_decode_busy),
        .data_i(i_inst),
        .data_o(prev_inst)
    );

    // decompressor instantiation 
    logic [15:0] decomp_in;
    logic [31:0] decomp_out;
    decompressor decompressor_inst (
        .ins_16(decomp_in),
        .ins_32(decomp_out)
    );
    assign is_comp = ~(decomp_in[1:0] == 2'b11);
    assign o_is_illegal = ~|decomp_in;
    assign next_is_comp = ~(i_inst[17:16] == 2'b11);



    // FSM Based Controller
    typedef enum logic [1:0] {
        STATE_NORMAL      = 2'b00,
        STATE_FETCH_UPPER = 2'b01,
        STATE_HOLD        = 2'b10
    } iadu_state_t;

    iadu_state_t state, next_state;


    always_ff @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            state <= STATE_NORMAL;
        end else if(~i_decode_busy) begin
            state <= next_state;
        end
    end

    // NEXT STATE LOGIC
    always_comb begin 
        case(state) 
        STATE_NORMAL: begin 
            if(its_a_jump)        next_state = STATE_NORMAL;
            else if(pc_misaligned) begin 
                if(next_is_comp) next_state = STATE_NORMAL;
                else             next_state = STATE_FETCH_UPPER;   
            end
            else begin 
                if(is_comp & ~o_is_illegal) begin 
                    if(next_is_comp) next_state = STATE_HOLD;
                    else             next_state = STATE_FETCH_UPPER;
                end else next_state = STATE_NORMAL;
            end 
        end
        STATE_FETCH_UPPER: begin 
            if(its_a_jump)        next_state = STATE_NORMAL;
            else if(next_is_comp) next_state = STATE_HOLD;
            else                  next_state = STATE_FETCH_UPPER;
        end
        STATE_HOLD: begin 
            next_state = STATE_NORMAL;
        end
        default: next_state = STATE_NORMAL;
        endcase
    end

    // OUTPUT LOGIC
    always_comb begin 
        o_increment_pc_by_2 = 'd0;
        decomp_in = i_inst[15:0];
        o_hold = 'd0; 
        o_pc_corrected = 'd0;
        o_is_comp = 'd0;
        o_inst    = 'd0;
        o_fetch_busy = 'd0;  
        case(state) 
        STATE_NORMAL: begin 
            o_pc_corrected = i_pc;
            if(pc_misaligned) begin 
                decomp_in = i_inst[31:16];
                if(next_is_comp) begin 
                            o_inst = decomp_out;
                            o_is_comp = 1'b1;
                            o_increment_pc_by_2 = 1;
                end else    begin 
                    o_inst = NOP;  
                    o_fetch_busy = 1'b1;
                    o_is_comp = 1'b0;
                end
            end
            else if(is_comp & ~o_is_illegal) begin 
                o_inst = decomp_out;
                o_is_comp = 1'b1;
                if(next_is_comp & ~its_a_jump) o_hold = 1;
                else             o_hold = 0;
            end
            else            begin 
                o_inst = i_inst;
                o_is_comp = 1'b0;
            end
        end
        STATE_FETCH_UPPER: begin
            if(next_is_comp & ~its_a_jump) o_hold = 1;
            else             o_hold = 0;
            if(pc_misaligned) begin 
                o_pc_corrected = i_pc - 4;
                o_increment_pc_by_2 = 1;
            end 
            else o_pc_corrected = i_pc - 2;
            decomp_in = 16'b0;
            o_is_comp = 1'b0;
            o_inst    = {i_inst[15:0], prev_inst[31:16]};
        end
        STATE_HOLD: begin
            o_hold = 0; 
            o_pc_corrected = i_pc - 2;
            decomp_in = prev_inst[31:16];
            o_is_comp = 1'b1;
            o_inst    = decomp_out;
        end
        default:  begin 
            o_hold = 'd0; 
            o_pc_corrected = 'd0;
            decomp_in = 'd0;
            o_is_comp = 'd0;
            o_inst    = 'd0;        
        end
        endcase
    end


    assign its_a_jump = (i_pc + 4) != i_pc_if1;


endmodule 