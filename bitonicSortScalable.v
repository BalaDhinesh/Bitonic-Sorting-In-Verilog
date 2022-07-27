//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date: 22/03/2022 
// Author: Bala Dhinesh
// Module Name: BitonicSortScalable
// Project Name: Bitonic Sorting in Verilog
//
//////////////////////////////////////////////////////////////////////////////////

// This code can work with any number of elements in the powers of 2. There are three primary states in the code, namely SORT, MERGE_SETUP, MERGE.
// **SORT**: Sort the array for every eight elements.
// **MERGE_SETUP**: This will make a bitonic sequence for the entire array.
// **MERGE**: Do the bitonic sort from the bitonic sequence array obtained from MERGE_SETUP.
// This code uses eight elements as a base for hardware and scaled from it. 

module BitonicSortScalable #(parameter BITWIDTH = 8, parameter ELEMENTS = 64)(
    input clk,
    input rst_n,
    input en_i,
    input [ELEMENTS*BITWIDTH-1:0] in,
    output reg done_o,
    output reg [ELEMENTS*BITWIDTH-1:0] out
);

    // FSM states
    localparam  START = 3'b000,
                SETUP = 3'b001,
                SORT = 3'b010,
                DONE = 3'b011,
                MERGE_SETUP = 3'b100,
                MERGE = 3'b101,
                IDLE = 3'b111;

    reg positive;                               // sort ascending or descending for intermediate sub-arrays
    reg [2:0] state;                            // state of FSM
    reg [$clog2(ELEMENTS)-1:0] stage;
    reg [7:0] d[0:7];                           // temporary register array
    reg [2:0] step;               

    // Register variables for Bitonic merge
    reg [$clog2(ELEMENTS):0] compare;
    reg [$clog2(ELEMENTS)-1:0] i_MERGE;
    reg [$clog2(ELEMENTS)-1:0] sum;
    reg [$clog2(ELEMENTS)-1:0] sum_max;
    reg [$clog2(ELEMENTS):0] STAGES = ELEMENTS/16;
    reg [$clog2(ELEMENTS):0] STAGES_FIXED = ELEMENTS/16;

    always @(posedge clk or negedge rst_n)
        if (!rst_n) begin
            out <= 0;
            step <= 4'd0;
            done_o <= 1'd0;
            state <= START;
        end else begin
            case(state)
                START:
                    begin
                        step <= 0;
                        done_o <= 1'd0;
                        compare <= ELEMENTS;
                        i_MERGE <= 0;
                        positive <= 1;
                        sum <= 8;
                        sum_max <= 8;
                        out <= in;
                        if(en_i) begin
                            state <= SETUP;
                            stage <= 0;
                        end
                    end 
                SETUP:
                    begin
                        if(stage <= (ELEMENTS/8)) begin
                            d[0] <= in[stage*8*BITWIDTH + 0*BITWIDTH +: 8];
                            d[1] <= in[stage*8*BITWIDTH + 1*BITWIDTH +: 8];
                            d[2] <= in[stage*8*BITWIDTH + 2*BITWIDTH +: 8];
                            d[3] <= in[stage*8*BITWIDTH + 3*BITWIDTH +: 8];
                            d[4] <= in[stage*8*BITWIDTH + 4*BITWIDTH +: 8];
                            d[5] <= in[stage*8*BITWIDTH + 5*BITWIDTH +: 8];
                            d[6] <= in[stage*8*BITWIDTH + 6*BITWIDTH +: 8];
                            d[7] <= in[stage*8*BITWIDTH + 7*BITWIDTH +: 8];
                            state <= SORT;
                        end
                        else begin
                            state <= START;
                        end
                    end
                SORT:
                    begin
                        case(step)
                            0: begin
                                if(d[0] > d[1]) begin
                                    d[0] <= d[1];
                                    d[1] <= d[0];
                                end
                                if(d[2] < d[3]) begin
                                    d[2] <= d[3];
                                    d[3] <= d[2];
                                end
                                if(d[4] > d[5]) begin
                                    d[4] <= d[5];
                                    d[5] <= d[4];
                                end
                                if(d[6] < d[7]) begin
                                    d[6] <= d[7];
                                    d[7] <= d[6];
                                end
                                step <= step + 1;
                            end
                            1: begin
                                if(d[0] > d[2]) begin
                                    d[0] <= d[2];
                                    d[2] <= d[0];
                                end
                                if(d[1] > d[3]) begin
                                    d[1] <= d[3];
                                    d[3] <= d[1];
                                end
                                if(d[4] < d[6]) begin
                                    d[4] <= d[6];
                                    d[6] <= d[4];
                                end
                                if(d[5] < d[7]) begin
                                    d[5] <= d[7];
                                    d[7] <= d[5];
                                end
                                step <= step + 1;
                            end
                            2: begin
                                if(d[0] > d[1]) begin
                                    d[0] <= d[1];
                                    d[1] <= d[0];
                                end
                                if(d[2] > d[3]) begin
                                    d[2] <= d[3];
                                    d[3] <= d[2];
                                end
                                if(d[4] < d[5]) begin
                                    d[4] <= d[5];
                                    d[5] <= d[4];
                                end
                                if(d[6] < d[7]) begin
                                    d[6] <= d[7];
                                    d[7] <= d[6];
                                end
                                step <= step + 1;
                            end
                            3: begin
                                if(stage%2 ==0) begin
                                    if(d[0] > d[4]) begin
                                        d[0] <= d[4];
                                        d[4] <= d[0];
                                    end
                                    if(d[1] > d[5]) begin
                                        d[1] <= d[5];
                                        d[5] <= d[1];
                                    end
                                    if(d[2] > d[6]) begin
                                        d[2] <= d[6];
                                        d[6] <= d[2];
                                    end
                                    if(d[3] > d[7]) begin
                                        d[3] <= d[7];
                                        d[7] <= d[3];
                                    end
                                end
                                else begin
                                    if(d[0] < d[4]) begin
                                        d[0] <= d[4];
                                        d[4] <= d[0];
                                    end
                                    if(d[1] < d[5]) begin
                                        d[1] <= d[5];
                                        d[5] <= d[1];
                                    end
                                    if(d[2] < d[6]) begin
                                        d[2] <= d[6];
                                        d[6] <= d[2];
                                    end
                                    if(d[3] < d[7]) begin
                                        d[3] <= d[7];
                                        d[7] <= d[3];
                                    end
                                end
                                step <= step + 1;
                            end
                            4: begin
                                if(stage%2 ==0) begin
                                    if(d[0] > d[2]) begin
                                        d[0] <= d[2];
                                        d[2] <= d[0];
                                    end
                                    if(d[1] > d[3]) begin
                                        d[1] <= d[3];
                                        d[3] <= d[1];
                                    end
                                    if(d[4] > d[6]) begin
                                        d[4] <= d[6];
                                        d[6] <= d[4];
                                    end
                                    if(d[5] > d[7]) begin
                                        d[5] <= d[7];
                                        d[7] <= d[5];
                                    end
                                end
                                else begin
                                    if(d[0] < d[2]) begin
                                        d[0] <= d[2];
                                        d[2] <= d[0];
                                    end
                                    if(d[1] < d[3]) begin
                                        d[1] <= d[3];
                                        d[3] <= d[1];
                                    end
                                    if(d[4] < d[6]) begin
                                        d[4] <= d[6];
                                        d[6] <= d[4];
                                    end
                                    if(d[5] < d[7]) begin
                                        d[5] <= d[7];
                                        d[7] <= d[5];
                                    end
                                end
                                step <= step + 1;
                            end
                            5: begin
                                if(stage%2 ==0) begin
                                    if(d[0] > d[1]) begin
                                        d[0] <= d[1];
                                        d[1] <= d[0];
                                    end
                                    if(d[2] > d[3]) begin
                                        d[2] <= d[3];
                                        d[3] <= d[2];
                                    end
                                    if(d[4] > d[5]) begin
                                        d[4] <= d[5];
                                        d[5] <= d[4];
                                    end
                                    if(d[6] > d[7]) begin
                                        d[6] <= d[7];
                                        d[7] <= d[6];
                                    end
                                end
                                else begin
                                    if(d[0] < d[1]) begin
                                        d[0] <= d[1];
                                        d[1] <= d[0];
                                    end
                                    if(d[2] < d[3]) begin
                                        d[2] <= d[3];
                                        d[3] <= d[2];
                                    end
                                    if(d[4] < d[5]) begin
                                        d[4] <= d[5];
                                        d[5] <= d[4];
                                    end
                                    if(d[6] < d[7]) begin
                                        d[6] <= d[7];
                                        d[7] <= d[6];
                                    end
                                end
                                step <= 4'd0;
                                state <= DONE;
                            end
                            default: step <= 4'd0;
                        endcase
                    end
                DONE: begin
                    if(stage == (ELEMENTS/8 - 1)) begin                    
                        out[stage*8*BITWIDTH + 0*BITWIDTH +: 8] <= d[0];
                        out[stage*8*BITWIDTH + 1*BITWIDTH +: 8] <= d[1];
                        out[stage*8*BITWIDTH + 2*BITWIDTH +: 8] <= d[2];
                        out[stage*8*BITWIDTH + 3*BITWIDTH +: 8] <= d[3];
                        out[stage*8*BITWIDTH + 4*BITWIDTH +: 8] <= d[4];
                        out[stage*8*BITWIDTH + 5*BITWIDTH +: 8] <= d[5];
                        out[stage*8*BITWIDTH + 6*BITWIDTH +: 8] <= d[6];
                        out[stage*8*BITWIDTH + 7*BITWIDTH +: 8] <= d[7];
                        if(ELEMENTS == 8) state <= IDLE;
                        else state <= MERGE_SETUP;
                        stage <= 0;
                        sum <= 8;
                        i_MERGE <= 0;
                        compare <= 16;
                    end
                    else if(stage < (ELEMENTS/8)) begin
                        out[stage*8*BITWIDTH + 0*BITWIDTH +: 8] <= d[0];
                        out[stage*8*BITWIDTH + 1*BITWIDTH +: 8] <= d[1];
                        out[stage*8*BITWIDTH + 2*BITWIDTH +: 8] <= d[2];
                        out[stage*8*BITWIDTH + 3*BITWIDTH +: 8] <= d[3];
                        out[stage*8*BITWIDTH + 4*BITWIDTH +: 8] <= d[4];
                        out[stage*8*BITWIDTH + 5*BITWIDTH +: 8] <= d[5];
                        out[stage*8*BITWIDTH + 6*BITWIDTH +: 8] <= d[6];
                        out[stage*8*BITWIDTH + 7*BITWIDTH +: 8] <= d[7];
                        state <= SETUP;
                        stage <= stage + 1;
                    end
                    else begin
                        out <= 110;
                        state <= IDLE;
                    end
                end
                MERGE_SETUP:
                    begin
                        if(STAGES == ELEMENTS | STAGES_FIXED == 1) begin
                            if(sum == ELEMENTS/2) begin
                                state <= MERGE;
                            end
                            else begin
                                sum <= sum_max * 2;
                                sum_max <= sum_max * 2;
                                state <= MERGE_SETUP;
                                i_MERGE <= 0;
                                compare <= sum_max*4;
                                positive <= 1;
                                stage <= 0;
                                STAGES <= STAGES_FIXED / 2;
                                STAGES_FIXED <= STAGES_FIXED / 2;
                            end
                        end
                        else begin
                            if((sum + i_MERGE) < compare && (compare <= ELEMENTS) && (stage < STAGES)) begin
                                if(positive) begin
                                    if(out[i_MERGE*BITWIDTH +: 8] > out[(i_MERGE+sum)*BITWIDTH +: 8]) begin
                                        out[i_MERGE*BITWIDTH +: 8] <= out[(i_MERGE+sum)*BITWIDTH +: 8];
                                        out[(i_MERGE+sum)*BITWIDTH +: 8] <= out[i_MERGE*BITWIDTH +: 8];
                                    end
                                end
                                else begin
                                    if(out[i_MERGE*BITWIDTH +: 8] < out[(i_MERGE+sum)*BITWIDTH +: 8]) begin
                                        out[i_MERGE*BITWIDTH +: 8] <= out[(i_MERGE+sum)*BITWIDTH +: 8];
                                        out[(i_MERGE+sum)*BITWIDTH +: 8] <= out[i_MERGE*BITWIDTH +: 8];
                                    end
                                end
                                if ((sum + i_MERGE) >= (compare - 1)) begin
                                    i_MERGE <= compare;
                                    compare <= compare + 2*sum;
                                    stage = stage + 1;
                                    if(STAGES == 2) begin
                                        if(stage == 0) positive <= 1;
                                        else positive <= 0;
                                    end
                                    else begin
                                        if((stage%(STAGES*2/STAGES_FIXED)) < STAGES/STAGES_FIXED) positive <= 1;
                                        else positive <= 0;
                                    end
                                    state <= MERGE_SETUP;
                                end
                                else begin
                                    i_MERGE = i_MERGE + 1;
                                    state <= MERGE_SETUP;
                                end
                            end
                            else begin
                                state <= MERGE_SETUP;
                                i_MERGE <= 0;
                                positive <= 1;
                                sum <= sum / 2;
                                compare <= sum;
                                stage <= 0;
                                STAGES <= STAGES * 2;
                            end
                        end
                    end
                MERGE:
                    begin
                        if(sum == 1) begin
                            state <= IDLE;
                            done_o <= 1;
                        end
                        else begin
                            if((sum + i_MERGE) < ELEMENTS) begin
                                if(out[i_MERGE*BITWIDTH +: 8] > out[(i_MERGE+sum)*BITWIDTH +: 8]) begin
                                    out[i_MERGE*BITWIDTH +: 8] <= out[(i_MERGE+sum)*BITWIDTH +: 8];
                                    out[(i_MERGE+sum)*BITWIDTH +: 8] <= out[i_MERGE*BITWIDTH +: 8];
                                end
                                if ((sum + i_MERGE) >= (compare - 1)) begin
                                    i_MERGE <= compare;
                                    compare <= compare * 2;
                                end
                                else begin
                                    i_MERGE = i_MERGE + 1;
                                    state <= MERGE;
                                end
                            end
                            else begin
                                state <= MERGE;
                                i_MERGE <= 0;
                                sum <= sum / 2;
                                compare <= sum;
                            end
                        end
                    end
                IDLE: state <= IDLE;
                default: state <= START;
            endcase
        end
endmodule