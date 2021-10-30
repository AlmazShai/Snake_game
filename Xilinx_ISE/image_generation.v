`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:56:22 12/14/2020 
// Design Name: 
// Module Name:    build_snake
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

`define STEP_DELAY 4194303//28'h3FFFFF;	//�������� 1 ���� ����

module build_snake(
    input clk,
    input rst,
	 input [1:0] direction,
	 input [59:0] read_data,
	 output reg [5:0] rw_address,
	 output reg wr_en,
    output reg [59:0] write_data
    );
	
	 
reg [11:0] din;
wire [11:0] dout;
reg wr_en_fifo, rd_en_fifo;

reg [5:0] dotx_keep, doty_keep;

reg [5:0] dotx_pos = 6'd3;
reg [5:0] doty_pos = 6'd0;
	 
fifo my_fifo(
  .clk(clk), // input clk
  .din(din), // input [11 : 0] din
  .wr_en(wr_en_fifo), // input wr_en
  .rd_en(rd_en_fifo), // input rd_en
  .full(),		//full
  .empty(),
  .data_count(),
  .dout(dout) // output [11 : 0] dout
);

wire [11:0] gen_data;
gen my_gen (
    .rst(rst),
    .clk(clk),
    .enable(1'b1),
    .gen_data(gen_data)
    );
	 
parameter X_MAX = 59;
parameter Y_MAX = 33;



reg [2:0] init_state = 3'b0; 
reg init_done = 1'b0; 			//���� �������������

reg [5:0] state = INIT;

parameter [5:0] INIT = 6'd0,
						IDLE = 6'd1,
						SNAKE_STEP = 6'd2,
						SET_ADR = 6'd3,
						WAIT_DATA = 6'd4,
						KEEP_D = 6'd5,
						WRITE_D = 6'd6,
						GEN_DOT = 6'd7,
						TAKE_ADR = 6'd8,
						SET_ADR2 = 6'd9,
						WAIT_DATA2 = 6'd10,
						KEEP_D2 = 6'd11,
						WRITE_D2 = 6'd12,
						SET_ADR3 = 6'd13,
						WAIT_DATA3 = 6'd14,
						CHECK_DOT = 6'd15,
						WRITE_D3 = 6'd16,
						GAME_OVER = 6'd17;
				
reg [59:0] data_keep; 			//������� ��� �������� ������, ������� �� RAM
reg we = 1'b0;						//����������� ������ � ������
reg [27:0] counter = 28'b0;	//�������-�������� ������ ����			
reg [5:0] mainx_pos = 6'd2;	//������������� ������� ������ ����
reg [5:0] mainy_pos = 6'b0;	//������������ ������� ������ ����
reg [5:0] tailx_pos = 6'b0;	//�������������� ������� ������ ����

reg [10:0] snake_lengh = 11'd3; //����� ����, ���������� = 3
reg [5:0] bodyx_pos ;				//�������������� ������� ������
reg [5:0] bodyy_pos;					//������������ ������� ������


wire eaten = (dotx_pos == mainx_pos) & (doty_pos == mainy_pos);

always@(posedge clk or negedge rst)
	if(!rst)
		state <= INIT;
	else
		case(state)
			INIT:
				if(init_done)
					state <= IDLE;
			IDLE:
				if(counter == `STEP_DELAY)
					state <= SNAKE_STEP;
				else
					state <= IDLE;
			SNAKE_STEP:
				state <= SET_ADR;
			SET_ADR:
				state <= WAIT_DATA;
			WAIT_DATA:
				state <= KEEP_D;
			KEEP_D: 
					state <= WRITE_D;
			WRITE_D:
				if((data_keep[mainx_pos] == 1'b1) & !eaten)
					state <= GAME_OVER;
				else if(eaten)
					state <= GEN_DOT;
				else
					state <= TAKE_ADR;
			
			TAKE_ADR:
				state <= SET_ADR2;
			SET_ADR2:
				state <= WAIT_DATA2;
			WAIT_DATA2:
				state <= KEEP_D2;
			KEEP_D2:
				state <= WRITE_D2;
			WRITE_D2:
				state <= IDLE;
			GEN_DOT:
				if(((gen_data >> 6) <= Y_MAX) & ((gen_data & 6'h3F) <= X_MAX))  ///< �������������� ����� �� ������ ���� ������ ��� X_MAX � Y_MAX
					state <= SET_ADR3;
				else
					state <= GEN_DOT;
			SET_ADR3:
				state <= WAIT_DATA3;
			WAIT_DATA3:
				state <= CHECK_DOT;
			CHECK_DOT:
				if(read_data[dotx_pos] == 1'b0)
					state <= WRITE_D3;
				else 
					state <= GEN_DOT;
			WRITE_D3:
				state <= IDLE;
			GAME_OVER:
				state <= GAME_OVER;
					
			default :
				state <= INIT;
	endcase

//-------------��������� �������� ��������----------------
always@(posedge clk or negedge rst)
	if(!rst)
		counter <= 0;
	else
		if(state == IDLE)
			counter <= counter + 1'b1;
		else 
			counter <= 1'b0;
				

always @(posedge clk or negedge rst)
if(!rst)
	begin
		wr_en_fifo <= 1'b0;
		init_state <= 3'b0;
		wr_en <= 1'b0;
		rd_en_fifo <= 1'b0;
		din <= 12'b0;
		data_keep <= 60'b0;
		mainx_pos <= 6'd2;
		mainy_pos <= 6'd0;
	end
else
	case(state)
		INIT:
			begin
			case(init_state)
				3'd0:
					begin
						din <= 12'b1;
						wr_en_fifo <= 1'b1;
						init_state <= 3'd1;
					end
				3'd1:
					begin
						din <= 12'd2;
						init_state <= 3'd3;
					end
				3'd2:
					begin
						din <= 12'd3;
						init_state <= 3'd3;
					end
				3'd3:
					begin
						wr_en_fifo <= 1'b0;
						init_state <= 3'd4;
						init_done <= 1'b1;
					end
				3'd4:
					init_state <= 3'd4;
				default :
					init_state <= 3'd2;
			endcase
			end
	//���������� ������� ����//
		IDLE:
			begin
				wr_en <= 1'b0;
			end
		//��������� ������ ����--------------------------
		SNAKE_STEP:
			begin
				case(direction)
					2'b00 : 
						if(mainx_pos >= X_MAX)
							mainx_pos <= 6'b0;
						else
							mainx_pos <= mainx_pos + 6'b1;
					2'b01 :
						if(mainy_pos >= Y_MAX)
							mainy_pos <= 6'b0;
						else
							mainy_pos <= mainy_pos + 6'b1;
					2'b10:
						if(mainx_pos == 6'b0)
							mainx_pos <= X_MAX;
						else
							mainx_pos <= mainx_pos - 6'b1;
					2'b11 :
						if(mainy_pos == 6'b0)
							mainy_pos <= Y_MAX;
						else
							mainy_pos <= mainy_pos - 6'b1;
				endcase
			end
		//������������� ����� � ������ ram-----------------
		SET_ADR:
			begin
				rw_address <= mainy_pos; 
				wr_en_fifo <= 1'b1;										//���������� ������ � fifo
				din <= {{mainy_pos[5:0]}, {mainx_pos[5:0]}};		//������ ������ �� ������
			end
		WAIT_DATA:
			wr_en_fifo <= 1'b0;			//���������� ��� ���������� ������ fifo
		//���������� ���������� �������� ������------------
		KEEP_D:
			begin
				
				//we <= 1'b1;						//������������� ��� ���������� ������ � rom
				
				data_keep <= read_data;		//��������� ���������� �������� rom
			end
		//��������� �������� ������ � ������ ���� ����-----
		WRITE_D:
			begin
				wr_en <= 1'b1;
				write_data <= data_keep | (1 << mainx_pos);
			end
	//------------------------------------------------------------//		
	//���������� ������� ����//
		//������� �������� ������ �� fifo
			TAKE_ADR:
				begin
					rd_en_fifo <= 1'b1;
					wr_en <= 1'b0;
				end
		//�������� �������� ������� ������, ������ ����� ������ � ram 
			SET_ADR2:
				begin
					rw_address[5:0] <= (dout >> 6);
					tailx_pos[5:0] <= dout[5:0];
					rd_en_fifo <= 1'b0;
				end
		//���������� ���������� �������� ram				
			KEEP_D2:
				begin
					data_keep <= read_data;
				end
		//���������� ����� �������� � ������ ���������
			WRITE_D2:
				begin
					wr_en <= 1'b1;
					write_data <= data_keep & ~(1 << tailx_pos);
				end
	//-------------��������� ����� �����----------------------
		//��������� ����� �������� ����� � ���������� 
			GEN_DOT:
				begin
					{{doty_pos[5:0]}, {dotx_pos[5:0]}} <= gen_data;
					wr_en <= 1'b0;
				end
		//���������� ���������� �������� ������
			SET_ADR3:
				rw_address <= doty_pos;
		//���������� ���������� �������� ������
			CHECK_DOT:
				data_keep <= read_data;
		//���������� ���������� ����� ����� � ������ ������� �����������
			WRITE_D3:
				begin
					wr_en <= 1'b1;
					write_data <= data_keep | (1 << dotx_pos);
				end
				
		endcase
		

endmodule
