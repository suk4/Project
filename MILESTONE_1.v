`timescale 1ns/100ps
`default_nettype none

`include "define_state.h"


module SRAM_editor (
    input logic 		Clock,
	input logic 		resetn,
    output logic [17:0] SRAM_address,
    input  logic [15:0] SRAM_read_data,
	output logic [15:0] SRAM_write_data,
	output logic 		SRAM_we_n,
	input logic 		SRAM_editor_n,
	output logic 		Milestone_end
);
logic resetn;

MILESTONE1_state_type MILESTONE1_state;


logic [17:0] SRAM_address;
logic [15:0] SRAM_write_data;
logic SRAM_we_n;
logic [15:0] SRAM_read_data;
logic SRAM_ready;
logic [17:0] base_U;	
logic [17:0] base_V;
logic [15:0] U_buffer;
logic [15:0] V_buffer;
logic Milestone_end;

logic [7:0] U_up_reg[3:0];
logic [7:0] V_up_reg[3:0];
logic [15:0] U_prime_reg;
logic [15:0] V_prime_reg;
logic [17:0] Y_count;
logic [17:0] U_count;
logic [17:0] V_count;
logic [15:0] MAC[1:0];
logic [15:0] U_temp;
logic [15:0] V_temp;
logic [15:0] Y_temp;	
logic select;
logic [15:0] input1;
logic [15:0] input2;
logic [8:0] Red_reg[1:0]
logic [8:0] Green_reg[1:0]
logic [8:0] Blue_reg[1:0]

always_comb begin
if (select == 1'd0) begin
op1 = U_up_reg[5];
op2 = multiUP;
end
else begin
op1 = input1;
op2 = multiCC;
end
end
assign multresult1 = op1*op2;

always_comb begin
if (select == 1'd0) begin
op1 = V_up_reg[5];
op2 = multiUP;
end
else begin
op1 = input2;
op2 = multiCC;
end
end
assign multresult2 = op1*op2;


always_ff @ (posedge Clock or negedge Resetn) begin
	if (Resetn == 1'b0) begin
			
		
		SRAM_address <= 18'd0;
		SRAM_we_n <= 1'b1;
		base_U <= 18'd38400;
		base_V <= 18'd57600;
		U_count <= 18'd0;
		V_count <= 18'd0;
						
	end else begin
		
			case (MILESTONE1_state)
				S_M1_IDLE: begin
					SRAM_we_n <= 1'd1;
					
					if(SRAM_editor_n) begin
						MILESTONE1_state <= S_M1_IDLE;
					end else begin
						MILESTONE1_state <= S_M1_LEAD_1;
					end
				end
				S_M1_LEAD_1:begin
					SRAM_address <= U_count + base_U;
					U_count <= U_count + 18'd1;
					MILESTONE1_state <= S_M1_LEAD_2;
				end
				S_M1_LEAD_2:begin
					SRAM_address <= U_count + base_U;
					U_count <= U_count + 18'd1;
					MILESTONE1_state <= S_M1_LEAD_3;
				end
				S_M1_LEAD_3:begin
					SRAM_address <= V_count + base_V;
					V_count <= V_count + 18'd1;
					MILESTONE1_state <= S_M1_LEAD_4;
				end
				S_M1_LEAD_4:begin
					SRAM_address <= V_count + base_V;
					V_count <= V_count + 18'd1;
					U_up_reg[5] <= SRAM_read_data[15:8];
					U_up_reg[4] <= SRAM_read_data[15:8];
					U_up_reg[3] <= SRAM_read_data[15:8];
					U_up_reg[2] <= SRAM_read_data[7:0];
					
					MILESTONE1_state <= S_M1_LEAD_5;
				end
				S_M1_LEAD_5:begin
					SRAM_address <= U_count + base_U;
					U_count <= U_count + 18'd1;
					U_up_reg[1] <= SRAM_read_data[15:8];
					U_up_reg[0] <= SRAM_read_data[7:0];
					MILESTONE1_state <= S_M1_LEAD_6;
				end
				S_M1_LEAD_6:begin
					SRAM_address <= V_count + base_V;
					V_count <= V_count + 18'd1;
					
					V_up_reg[5] <= SRAM_read_data[15:8];
					V_up_reg[4] <= SRAM_read_data[15:8];
					V_up_reg[3] <= SRAM_read_data[15:8];
					V_up_reg[2] <= SRAM_read_data[7:0];
					MILESTONE1_state <= S_M1_LEAD_7;
				end
				S_M1_LEAD_7:begin
					V_up_reg[1] <= SRAM_read_data[15:8];
					V_up_reg[0] <= SRAM_read_data[7:0];
				end
				S_M1_LEAD_8:begin
					U_buffer <= SRAM_read_data;
					U_prime_reg <= 16'd128;
					V_prime_reg <= 16'd128;
				end
				
				S_M1_UP_1:begin
					select <= 1'd0;
					V_buffer <= SRAM_read_data[7:0]
					//21
					U_up_reg[5] <= U_up_reg[0];
					U_up_reg[4] <= U_up_reg[0];
					U_up_reg[3] <= U_up_reg[0];
					U_up_reg[2] <= U_up_reg[0];
					U_up_reg[1] <= U_up_reg[0];
					U_up_reg[0] <= U_buffer[15:8];
					
					V_up_reg[5] <= V_up_reg[4];
					V_up_reg[4] <= V_up_reg[3];
					V_up_reg[3] <= V_up_reg[2];
					V_up_reg[2] <= V_up_reg[1];
					V_up_reg[1] <= V_up_reg[0];
					V_up_reg[0] <= SRAM_read_data[15:8];
					
					U_prime_reg <= U_prime_reg + multresult1;
					V_prime_reg <= V_prime_reg + multresult2;
				end
				S_M1_UP_2:begin
					//52 minus
					U_up_reg[5] <= U_up_reg[0];
					U_up_reg[4] <= U_up_reg[0];
					U_up_reg[3] <= U_up_reg[0];
					U_up_reg[2] <= U_up_reg[0];
					U_up_reg[1] <= U_up_reg[0];
					U_up_reg[0] <= U_up_reg[5];
					
					V_up_reg[5] <= V_up_reg[4];
					V_up_reg[4] <= V_up_reg[3];
					V_up_reg[3] <= V_up_reg[2];
					V_up_reg[2] <= V_up_reg[1];
					V_up_reg[1] <= V_up_reg[0];
					V_up_reg[0] <= V_up_reg[5];
					
					U_prime_reg <= U_prime_reg - multresult1;
					V_prime_reg <= V_prime_reg - multresult2;
				end
				S_M1_UP_3:begin
					//159
					U_up_reg[5] <= U_up_reg[0];
					U_up_reg[4] <= U_up_reg[0];
					U_up_reg[3] <= U_up_reg[0];
					U_up_reg[2] <= U_up_reg[0];
					U_up_reg[1] <= U_up_reg[0];
					U_up_reg[0] <= U_up_reg[5];
					
					V_up_reg[5] <= V_up_reg[4];
					V_up_reg[4] <= V_up_reg[3];
					V_up_reg[3] <= V_up_reg[2];
					V_up_reg[2] <= V_up_reg[1];
					V_up_reg[1] <= V_up_reg[0];
					V_up_reg[0] <= V_up_reg[5];
					
					U_prime_reg <= U_prime_reg + multresult1;
					V_prime_reg <= V_prime_reg + multresult2;
				end
				S_M1_UP_4:begin
					//159
					SRAM_address <= Y_count;
					Y_count <= Y_count + 18'd1;
					U_up_reg[5] <= U_up_reg[0];
					U_up_reg[4] <= U_up_reg[0];
					U_up_reg[3] <= U_up_reg[0];
					U_up_reg[2] <= U_up_reg[0];
					U_up_reg[1] <= U_up_reg[0];
					U_up_reg[0] <= U_up_reg[5];
					
					V_up_reg[5] <= V_up_reg[4];
					V_up_reg[4] <= V_up_reg[3];
					V_up_reg[3] <= V_up_reg[2];
					V_up_reg[2] <= V_up_reg[1];
					V_up_reg[1] <= V_up_reg[0];
					V_up_reg[0] <= V_up_reg[5];
					
					U_prime_reg <= U_prime_reg + multresult1;
					V_prime_reg <= V_prime_reg + multresult2;
				end
				S_M1_UP_5:begin
					//52 minus
					
					U_up_reg[5] <= U_up_reg[0];
					U_up_reg[4] <= U_up_reg[0];
					U_up_reg[3] <= U_up_reg[0];
					U_up_reg[2] <= U_up_reg[0];
					U_up_reg[1] <= U_up_reg[0];
					U_up_reg[0] <= U_up_reg[5];
					
					V_up_reg[5] <= V_up_reg[4];
					V_up_reg[4] <= V_up_reg[3];
					V_up_reg[3] <= V_up_reg[2];
					V_up_reg[2] <= V_up_reg[1];
					V_up_reg[1] <= V_up_reg[0];
					V_up_reg[0] <= V_up_reg[5];
					
					U_prime_reg <= U_prime_reg - multresult1;
					V_prime_reg <= V_prime_reg - multresult2;
				end
				S_M1_UP_6: begin
					//21
					U_up_reg[5] <= U_up_reg[0];
					U_up_reg[4] <= U_up_reg[0];
					U_up_reg[3] <= U_up_reg[0];
					U_up_reg[2] <= U_up_reg[0];
					U_up_reg[1] <= U_up_reg[0];
					U_up_reg[0] <= U_up_reg[5];
					
					V_up_reg[5] <= V_up_reg[4];
					V_up_reg[4] <= V_up_reg[3];
					V_up_reg[3] <= V_up_reg[2];
					V_up_reg[2] <= V_up_reg[1];
					V_up_reg[1] <= V_up_reg[0];
					V_up_reg[0] <= V_up_reg[5];
					
					U_prime_reg <= U_prime_reg + multresult1;
					V_prime_reg <= V_prime_reg + multresult2;
				end
				
				S_M1_UP_7: begin
					//multiply 128 x 1 and load into register
					U_up_reg[5] <= U_up_reg[0];
					U_up_reg[4] <= U_up_reg[0];
					U_up_reg[3] <= U_up_reg[0];
					U_up_reg[2] <= U_up_reg[0];
					U_up_reg[1] <= U_up_reg[0];
					U_up_reg[0] <= U_up_reg[5];
					
					V_up_reg[5] <= V_up_reg[4];
					V_up_reg[4] <= V_up_reg[3];
					V_up_reg[3] <= V_up_reg[2];
					V_up_reg[2] <= V_up_reg[1];
					V_up_reg[1] <= V_up_reg[0];
					V_up_reg[0] <= V_up_reg[5];
					
					U_prime_reg <= 16'd128;
					V_prime_reg <= 16'd128;
					
					U_temp <= U_prime_reg;
					V_temp <= V_prime_reg;
					Y_temp <= SRAM_read_data
					input1 <= Y_temp[15:8];
					input2 <= Y_temp[7:0];
					multiCC <= 15'd76284;
				end
				
				S_M1_CC_1:begin
				
					//Y Loaded in Red registers
					select <=1'd1;
					Red_reg[1]<= multresult2;
					Red_reg[0]<= multresult1;
					input1 <= V_temp_even - 16'd128;
					input2 <= V_temp - 16'd128;
					multiCC <= 15'd104595;
					Y_mult_temp_E <= multresult2;
					Y_mult_temp_O <= multresult1;
					
					
				end
				S_M1_CC_2:begin
					// V loaded in Red registers
					Red_reg[1]<= Red_reg[1] + multresult2;
					Red_reg[0] <= Red_reg[0] + multresult1;
					
					multiCC <= 15'd53281;
				end
				S_M1_CC_3:begin
				
					//Y and V loaded into Green Registers
					Green_reg[1] <= Y_mult_temp_E - multresult2;
					Green_reg[0] <= Y_mult_temp_O - multresult1;
					input1 <= U_temp_even - 16'd128;
					input2 <= U_temp - 16'd128;
					multiCC <= 15'd25624;
				end
				S_M1_CC_4:begin
					//U loaded into Green register
					Green_reg[1] <= Green_reg[1] - multresult2;
					Green_reg[0] <= Green_reg[0] - multresult1;
					
					multiCC <= 15'd132251;
				end
				S_M1_CC_5:begin
				
					//Y and U loaded into Blue registers
					Blue_reg_reg[1] <= Y_mult_temp_E -multresult2;
					Blue_reg[0] <= Y_mult_temp_O - multresult1;
				end
				
			default: S_M1_IDLE
			endcase
		end
		// To generate a border
		if (pixel_Y_pos == 10'd0 || pixel_Y_pos == 10'd479
		 || pixel_X_pos == 10'd0 || pixel_X_pos == 10'd639) begin
			VGA_red <= 10'h3FF;
			VGA_green <= 10'h3FF;
			VGA_blue <= 10'h3FF;
		end
	end
end