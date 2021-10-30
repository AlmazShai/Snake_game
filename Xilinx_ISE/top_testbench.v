`timescale 1ns / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:42:29 12/06/2020
// Design Name:   top_LCD
// Module Name:   E:/projects/Xilinx/LCD_Project/top_testbench.v
// Project Name:  LCD_Project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_LCD
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_testbench;

	// Inputs
	reg clk_in;
	reg rst;

	// Outputs
	wire [7:0] r;
	wire [7:0] g;
	wire [7:0] b;
	wire v_sync;
	wire h_sync;
	wire de;
	wire clk_LCD;
	reg key1;
	reg key2;

	// Instantiate the Unit Under Test (UUT)
	top_LCD uut (
		.clk_in(clk_in), 
		.rst(rst),
		.key1(key1),
		.key2(key2),
		.r(r),
		.g(g),
		.b(b),
		.v_sync(v_sync), 
		.h_sync(h_sync), 
		.de(de), 
		.clk_LCD(clk_LCD)
	);

	initial begin
		// Initialize Inputs
		clk_in = 0;
		rst = 0;
		key1 = 1;
		key2 = 1;

		// Wait 100 ns for global reset to finish
		#10;
        
		rst = 1;
		#50;
		key1 = 0;
		#10000000;
		key1 = 1;
		#10000000;
		key1 = 0;
		#10000000;
		key1 = 1;
		// Add stimulus here

	end
      
	always
		#10 clk_in = ~clk_in;
	
endmodule

