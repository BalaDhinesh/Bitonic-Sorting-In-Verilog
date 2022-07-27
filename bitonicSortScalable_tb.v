//////////////////////////////////////////////////////////////////////////////////
// 
// Create Date: 22/03/2022 
// Author: Bala Dhinesh
// Module Name: BitonicSortScalable_tb
// Project Name: Bitonic Sorting in Verilog
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
`define clk_period 20

module BitonicSortScalable_tb #(
    parameter BITWIDTH = 8,         // Bitwidth of each element
    parameter ELEMENTS = 64         // Number of elements to be sorted. This value must be a powers of two
)
();

    reg clk, rst_n, en_i;
    reg [ELEMENTS*BITWIDTH-1:0] in;
    wire done_o;
    wire [ELEMENTS*BITWIDTH-1:0] out;

    BitonicSortScalable bitonic_SORT(
        clk,
        rst_n,
        en_i,
        in,
        done_o,
        out
    );

    integer i;
    initial begin
        clk = 1'b1;
    end

    always #(`clk_period/2) begin
        clk = ~clk;
    end

    initial begin
        rst_n = 0;
        en_i = 0;
        in = 0;

        #(`clk_period);
        rst_n = 1;
        en_i = 1;

        // Input array vector to sort. 
        // Increase the number of elements based on ELEMENTS parameter
        in ={   8'd28,  8'd23,  8'd24,  8'd16,  8'd11,  8'd25,  8'd29,  8'd1,
                8'd10,  8'd32,  8'd21,  8'd2,   8'd27,  8'd31,  8'd3,   8'd30,
                8'd15,  8'd13,  8'd0,   8'd8,   8'd5,   8'd18,  8'd22,  8'd26,
                8'd4,   8'd6,   8'd9,   8'd19,  8'd20,  8'd7,   8'd14,  8'd17,
                8'd28,  8'd23,  8'd24,  8'd16,  8'd11,  8'd25,  8'd29,  8'd1,
                8'd10,  8'd32,  8'd21,  8'd2,   8'd27,  8'd31,  8'd3,   8'd30,
                8'd15,  8'd13,  8'd0,   8'd8,   8'd5,   8'd18,  8'd22,  8'd26,
                8'd4,   8'd6,   8'd9,   8'd19,  8'd20,  8'd7,   8'd14,  8'd17,
                8'd28,  8'd23,  8'd24,  8'd16,  8'd11,  8'd25,  8'd29,  8'd1,
                8'd10,  8'd32,  8'd21,  8'd2,   8'd27,  8'd31,  8'd3,   8'd30,
                8'd15,  8'd13,  8'd0,   8'd8,   8'd5,   8'd18,  8'd22,  8'd26,
                8'd4,   8'd6,   8'd9,   8'd19,  8'd20,  8'd7,   8'd14,  8'd17,
                8'd28,  8'd23,  8'd24,  8'd16,  8'd11,  8'd25,  8'd29,  8'd1,
                8'd10,  8'd32,  8'd21,  8'd2,   8'd27,  8'd31,  8'd3,   8'd30,
                8'd15,  8'd13,  8'd0,   8'd8,   8'd5,   8'd18,  8'd22,  8'd26,
                8'd4,   8'd6,   8'd9,   8'd19,  8'd20,  8'd7,   8'd14,  8'd17
            };

        #(`clk_period);
        en_i = 0;

        #(`clk_period*10000);
        $display("Input array:");
        for(i=0;i<ELEMENTS;i=i+1)
        $write(in[i*BITWIDTH +: 8]);

        $display("\nOutput sorted array:");
        for(i=0;i<ELEMENTS;i=i+1)
        $write(out[i*BITWIDTH +: 8]);

        $display("\ndone %d", done_o);

        $finish;
    end

endmodule
