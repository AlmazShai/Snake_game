`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:32 01/02/2021 
// Design Name: 
// Module Name:    generate 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module gen(
    input rst,
    input clk,
    input enable,
    output reg [11:0] gen_data
    );

parameter TAPS = 12'b0000_0101_0011;

wire feedback = (^ (gen_data & TAPS));

always@(posedge clk or negedge rst)
	if(!rst)
		gen_data <= {{11{1'b0}}, 1'b1};
	else if (enable)
		gen_data <= {feedback, gen_data[11 : 1]};
		


endmodule
