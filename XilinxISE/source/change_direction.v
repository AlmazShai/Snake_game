`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:13:11 12/27/2020 
// Design Name: 
// Module Name:    change_direction 
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
module change_direction(
    input clk,
    input rst,
	 input key1,
    input key2,
    output [1:0] direction
    );

parameter [1:0] S0 = 2'b00,
					S1 = 2'b01,
					S2 = 2'b10,
					S3 = 2'b11;

reg [1:0] state, nextstate;

wire key1_out, key2_out;
button_debouncer #(16) button1
(
    .clk(clk),
    .rst(rst),
    .key(key1),
    .key_down(key1_out),
	 .key_up(),
	 .key_state()
    );
	 
	 
button_debouncer #(16) button2
(
    .clk(clk),
    .rst(rst),
    .key(key2),
    .key_down(key2_out),
	 .key_up(),
	 .key_state()
    );
	 
always@(posedge clk or negedge rst)
	if(!rst)
		state <= S0;
	else
		state <= nextstate;

always@(*)
	begin	
		nextstate = 2'bx;
		case(state)
			S0:
				if(key2_out)
					nextstate = S1;
				else if(key1_out)
					nextstate = S3;
				else
					nextstate = S0;
			S1:
				if(key2_out)
					nextstate = S2;
				else if(key1_out)
					nextstate = S0;
				else
					nextstate = S1;
			S2:
				if(key2_out)
					nextstate = S3;
				else if(key1_out)
					nextstate = S1;
				else
					nextstate = S2;
			S3:
				if(key2_out)
						nextstate = S0;
				else if(key1_out)
					nextstate = S2;
				else
					nextstate = S3;
		endcase
	end
	
assign direction = state;
		
endmodule
