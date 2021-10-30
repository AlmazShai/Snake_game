`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:44:32 12/06/2020 
// Design Name: 
// Module Name:    hv_position 
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
module hv_position(
    input clk_disp,
	 input clk_50MHz,
    input rst,
	 output de,
    output reg h_sync,
    output v_sync,
	 output inrange,
    output [9:0] x_pos,
    output [9:0] y_pos
    );
	
parameter H_CYCLE = 10'd524;				//525-1 число тактов в одной строке
parameter H_SYNC = 10'd40;					//41-1	передний фронт синхроимпульса
parameter H_FRONT = H_SYNC + 10'd2;		//начало рабочей области
parameter H_DISP = H_FRONT + 10'd480;	//конец рабочей области
parameter H_BACK = H_DISP + 10'd2;		//конец строки, по факту равняется H_CYCLE

parameter V_CYCLE = 10'd285;				//286-1	количество тактов H_SYNC
parameter V_SYNC = 10'd9;					//10-1	конец синхроимпульса
parameter V_TOP = V_SYNC + 10'd2;		//начало рабочей области
parameter V_DISP = V_TOP + 10'd272;		//конец рабочей области
parameter V_BOTTOM = V_DISP + 10'd2;	//конец невидимой области, по факту равно V_CYCLE

reg [9:0] h_count;
reg [9:0] v_count;

assign de = 1'b0;
wire pre_h_sync = (h_count > H_SYNC);
assign v_sync = ((v_count > V_SYNC) & (rst));
assign x_pos[9:0] = h_count[9:0] - H_FRONT;
assign y_pos[9:0] = v_count[9:0] - V_TOP;
assign inrange = (h_count > H_FRONT) & (h_count <= H_DISP) & (v_count > V_TOP) & (v_count <= V_DISP);

always@(negedge clk_disp or negedge rst)
	if(!rst)
		begin
			h_count <= 10'd0;
			v_count <= 10'd0;
		end
	else 
		if(h_count == H_CYCLE)
			begin
				h_count <= 10'd0;
				if(v_count == V_CYCLE)
					v_count <= 10'd0;
				else
					v_count <= v_count + 10'd1;
			end
		else
			h_count <= h_count + 10'b1;

always @(negedge clk_50MHz or negedge rst)
	if(!rst)
		h_sync <= 1'b1;
	else
		h_sync <= pre_h_sync;

endmodule
