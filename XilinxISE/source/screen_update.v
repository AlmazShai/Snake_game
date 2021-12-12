`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:52:31 12/06/2020 
// Design Name: 
// Module Name:    screen_update 
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
module screen_update(
    input rst,
    input inrange,
    input [9:0] x_pos,
    input [9:0] y_pos,
	 input [59:0] ram_in,
	 output [5:0] read_address,
    output [7:0] red,
    output [7:0] green,
    output [7:0] blue
    );
	 
	 

reg [7:0] red_r, green_r, blue_r;

	
assign read_address = y_pos[8:3];
assign red = (inrange) ? red_r : 8'b00000000;
assign green = (inrange) ? green_r : 8'b00000000;
assign blue = (inrange) ? blue_r : 8'b00000000;

always@(*)
	if(!rst)
		begin
			red_r = 8'd0;
			green_r = 8'd0;
			blue_r = 8'd0;
		end
	else 
		begin
			red_r[7:0] = ~{8{ram_in[x_pos[8:0] >> 3]}};
			green_r[7:0] = ~{8{ram_in[x_pos[8:0] >> 3]}};
			blue_r[7:0] = ~{8{ram_in[x_pos[8:0] >> 3]}};
		end


endmodule
