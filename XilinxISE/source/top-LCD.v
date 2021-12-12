`timescale 10ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:47:32 12/06/2020 
// Design Name: 
// Module Name:    top-LCD 
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
module top_LCD(
		input clk_in,
		input rst,
		input key1,
		input key2,
		output [7:0] r,
		output [7:0] g,
		output [7:0] b,
		output v_sync,
		output h_sync,
		output de,
		output clk_LCD
    );
	 
wire clk_9MHz, clk_9MHz_n, clk_50MHz;


ODDR2 #(
   // The following parameters specify the behavior
   // of the component.
   .DDR_ALIGNMENT("NONE"), // Sets output alignment
                           // to "NONE", "C0" or "C1"
   .INIT(1'b0),    // Sets initial state of the Q 
                   //   output to 1'b0 or 1'b1
   .SRTYPE("SYNC") // Specifies "SYNC" or "ASYNC"
                   //   set/reset
)
ODDR2_inst (
   .Q(clk_LCD),   // 1-bit DDR output data
   .C0(clk_9MHz), // 1-bit clock input
   .C1(clk_9MHz_n), // 1-bit clock input
   .CE(1'b1), // 1-bit clock enable input
   .D0(1'b1), // 1-bit data input (associated with C0)
   .D1(1'b0), // 1-bit data input (associated with C1)
   .R(1'b0),   // 1-bit reset input
   .S(1'b0)    // 1-bit set input
);

wire wr_en;
wire [5:0] rw_address, rw_address2;
wire [59:0] read_data, write_data, read_ram;
/*
ram2 my_ram (
  .clka(clk_in), // input clka
  .wea(wr_en), // input [0 : 0] wea
  .addra(rw_address), // input [5 : 0] addra
  .dina(write_data), // input [59 : 0] dina
  .douta(read_data), // output [59 : 0] douta
  .clkb(clk_in), // input clkb
  .web(1'b0), // input [0 : 0] web
  .addrb(rw_address2), // input [5 : 0] addrb
  .dinb({60{1'b1}}), // input [59 : 0] dinb
  .doutb(read_ram) // output [59 : 0] doutb
);*/

RAMB16BWER #(
      // DATA_WIDTH_A/DATA_WIDTH_B: 0, 1, 2, 4, 9, 18, or 36
      .DATA_WIDTH_A(36),
      .DATA_WIDTH_B(36),
      // DOA_REG/DOB_REG: Optional output register (0 or 1)
      .DOA_REG(0),
      .DOB_REG(0),
      // EN_RSTRAM_A/EN_RSTRAM_B: Enable/disable RST
      .EN_RSTRAM_A("TRUE"),
      .EN_RSTRAM_B("TRUE"),
		//.INIT_00(256'h0000000000000000000000000000000000000000000000000000000000000007),
		.INIT_A(36'h000000000),
      .INIT_B(36'h000000000),
		.INIT_FILE("NONE"),
      // RSTTYPE: "SYNC" or "ASYNC" 
      .RSTTYPE("SYNC"),
      // RST_PRIORITY_A/RST_PRIORITY_B: "CE" or "SR" 
      .RST_PRIORITY_A("CE"),
      .RST_PRIORITY_B("CE"),
      // SIM_COLLISION_CHECK: Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE" 
      .SIM_COLLISION_CHECK("ALL"),
      // SIM_DEVICE: Must be set to "SPARTAN6" for proper simulation behavior
      .SIM_DEVICE("SPARTAN6"),
      // SRVAL_A/SRVAL_B: Set/Reset value for RAM output
      .SRVAL_A(36'h000000000),
      .SRVAL_B(36'h000000000),
      // WRITE_MODE_A/WRITE_MODE_B: "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
      .WRITE_MODE_A("WRITE_FIRST"),
      .WRITE_MODE_B("WRITE_FIRST") 
		)
		 RAMB16BWER_top (
      // Port A Data: 32-bit (each) output: Port A data
      .DOA(read_data[31:0]),       // 32-bit output: A port data output
      .DOPA(),     // 4-bit output: A port parity output
      // Port B Data: 32-bit (each) output: Port B data
      .DOB(read_ram[31:0]),       // 32-bit output: B port data output
      .DOPB(),     // 4-bit output: B port parity output
      // Port A Address/Control Signals: 14-bit (each) input: Port A address and control signals
      .ADDRA({{rw_address[5:0]}, {8{1'b0}}}),   // 14-bit input: A port address input
      .CLKA(clk_in),     // 1-bit input: A port clock input
      .ENA(1'b1),       // 1-bit input: A port enable input
      .REGCEA(1'b0), // 1-bit input: A port register clock enable input
      .RSTA(~rst),     // 1-bit input: A port register set/reset input
      .WEA({4{wr_en}}),       // 4-bit input: Port A byte-wide write enable input
      // Port A Data: 32-bit (each) input: Port A data
      .DIA(write_data[31:0]),       // 32-bit input: A port data input
      .DIPA(4'b0),     // 4-bit input: A port parity input
      // Port B Address/Control Signals: 14-bit (each) input: Port B address and control signals
      .ADDRB({{rw_address2[5:0]},{8{1'b0}}}),   // 14-bit input: B port address input
      .CLKB(clk_in),     // 1-bit input: B port clock input
      .ENB(1'b1),       // 1-bit input: B port enable input
      .REGCEB(1'b0), // 1-bit input: B port register clock enable input
      .RSTB(~rst),     // 1-bit input: B port register set/reset input
      .WEB({4{1'b0}}),       // 4-bit input: Port B byte-wide write enable input
      // Port B Data: 32-bit (each) input: Port B data
      .DIB(32'b0),       // 32-bit input: B port data input
      .DIPB(4'b0)      // 4-bit input: B port parity input
   );

RAMB16BWER #(
      // DATA_WIDTH_A/DATA_WIDTH_B: 0, 1, 2, 4, 9, 18, or 36
      .DATA_WIDTH_A(36),
      .DATA_WIDTH_B(36),
      // DOA_REG/DOB_REG: Optional output register (0 or 1)
      .DOA_REG(0),
      .DOB_REG(0),
      // EN_RSTRAM_A/EN_RSTRAM_B: Enable/disable RST
      .EN_RSTRAM_A("TRUE"),
      .EN_RSTRAM_B("TRUE"),
		.INIT_A(36'h000000000),
      .INIT_B(36'h000000000),
		.INIT_FILE("NONE"),
      // RSTTYPE: "SYNC" or "ASYNC" 
      .RSTTYPE("SYNC"),
      // RST_PRIORITY_A/RST_PRIORITY_B: "CE" or "SR" 
      .RST_PRIORITY_A("CE"),
      .RST_PRIORITY_B("CE"),
      // SIM_COLLISION_CHECK: Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE" 
      .SIM_COLLISION_CHECK("ALL"),
      // SIM_DEVICE: Must be set to "SPARTAN6" for proper simulation behavior
      .SIM_DEVICE("SPARTAN6"),
      // SRVAL_A/SRVAL_B: Set/Reset value for RAM output
      .SRVAL_A(36'h000000000),
      .SRVAL_B(36'h000000000),
      // WRITE_MODE_A/WRITE_MODE_B: "WRITE_FIRST", "READ_FIRST", or "NO_CHANGE" 
      .WRITE_MODE_A("WRITE_FIRST"),
      .WRITE_MODE_B("WRITE_FIRST") 
		)
		 RAMB16BWER_bottom (
      // Port A Data: 32-bit (each) output: Port A data
      .DOA({read_data[59:32]}),       // 32-bit output: A port data output
      .DOPA(),     // 4-bit output: A port parity output
      // Port B Data: 32-bit (each) output: Port B data
      .DOB({read_ram[59:32]}),       // 32-bit output: B port data output
      .DOPB(),     // 4-bit output: B port parity output
      // Port A Address/Control Signals: 14-bit (each) input: Port A address and control signals
      .ADDRA({{rw_address[5:0]}, {8{1'b0}}}),   // 14-bit input: A port address input
      .CLKA(clk_in),     // 1-bit input: A port clock input
      .ENA(1'b1),       // 1-bit input: A port enable input
      .REGCEA(1'b0), // 1-bit input: A port register clock enable input
      .RSTA(~rst),     // 1-bit input: A port register set/reset input
      .WEA({4{wr_en}}),       // 4-bit input: Port A byte-wide write enable input
      // Port A Data: 32-bit (each) input: Port A data
      .DIA({{4{1'b0}}, {write_data[59:32]}}),       // 32-bit input: A port data input
      .DIPA(4'b0),     // 4-bit input: A port parity input
      // Port B Address/Control Signals: 14-bit (each) input: Port B address and control signals
      .ADDRB({{rw_address2[5:0]}, {8{1'b0}}}),   // 14-bit input: B port address input
      .CLKB(clk_in),     // 1-bit input: B port clock input
      .ENB(1'b1),       // 1-bit input: B port enable input
      .REGCEB(1'b0), // 1-bit input: B port register clock enable input
      .RSTB(~rst),     // 1-bit input: B port register set/reset input
      .WEB({4{1'b0}}),       // 4-bit input: Port B byte-wide write enable input
      // Port B Data: 32-bit (each) input: Port B data
      .DIB(32'b0),       // 32-bit input: B port data input
      .DIPB(4'b0)      // 4-bit input: B port parity input
   );


wire [1:0] direction;
build_snake my_build_snake(
    .clk(clk_in),
    .rst(rst),
	 .direction(direction),
	 .read_data(read_data),
	 .rw_address(rw_address),
	 .wr_en(wr_en),
    .write_data(write_data)
    );

CLK_PLL pll(
		.CLK_IN1(clk_in),
		.RESET(~rst),
		.CLK_OUT1(clk_9MHz),
		.CLK_OUT2(clk_9MHz_n)
	);

wire inrange;
wire [9:0] x_pos, y_pos;

hv_position hv_position1(
	 .clk_disp(clk_9MHz),
	 .clk_50MHz(clk_in),
    .rst(rst),
	 .de(de),
    .h_sync(h_sync),
    .v_sync(v_sync),
	 .inrange(inrange),
    .x_pos(x_pos),
    .y_pos(y_pos)
);

screen_update screen_update1(
    .rst(rst),
    .inrange(inrange),
    .x_pos(x_pos),
    .y_pos(y_pos),
	 .ram_in(read_ram),
	 .read_address(rw_address2),
    .red(r),
    .green(g),
    .blue(b)
);


change_direction ch_dir(
	 .clk(clk_in),
    .rst(rst),
	 .key1(key1),
    .key2(key2),
    .direction(direction)
);

endmodule
