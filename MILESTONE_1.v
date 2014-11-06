`timescale 1ns/100ps
`default_nettype none

`include "define_state.h"


module SRAM_editor (
	
	
	output logic            VGA_enable,
    input  logic   [17:0]   SRAM_base_address,
    output logic   [17:0]   SRAM_address,
    input  logic   [15:0]   SRAM_read_data,
	
	inout wire[15:0] SRAM_DATA_IO,            // SRAM data bus 16 bits
	output logic[17:0] SRAM_ADDRESS_O,        // SRAM address bus 18 bits
	output logic SRAM_UB_N_O,                 // SRAM high-byte data mask 
	output logic SRAM_LB_N_O,                 // SRAM low-byte data mask 
	output logic SRAM_WE_N_O,                 // SRAM write enable
	output logic SRAM_CE_N_O,                 // SRAM chip enable
	output logic SRAM_OE_N_O, 	
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
SRAM_editor UART_unit(
	.Clock(CLOCK_50_I),
	.Resetn(resetn), 
   
   
	// For accessing SRAM
	.SRAM_address(SRAM_address),
	.SRAM_write_data(SRAM_write_data),
	.SRAM_we_n(SRAM_we_n),
	
);

SRAM_Controller SRAM_unit (
	.Clock_50(CLOCK_50_I),
	.Resetn(~SWITCH_I[17]),
	.SRAM_address(SRAM_address),
	.SRAM_write_data(SRAM_write_data),
	.SRAM_we_n(SRAM_we_n),
	.SRAM_read_data(SRAM_read_data),		
	.SRAM_ready(SRAM_ready),
		
	// To the SRAM pins
	.SRAM_DATA_IO(SRAM_DATA_IO),
	.SRAM_ADDRESS_O(SRAM_ADDRESS_O),
	.SRAM_UB_N_O(SRAM_UB_N_O),
	.SRAM_LB_N_O(SRAM_LB_N_O),
	.SRAM_WE_N_O(SRAM_WE_N_O),
	.SRAM_CE_N_O(SRAM_CE_N_O),
	.SRAM_OE_N_O(SRAM_OE_N_O)
);

always_ff @ (posedge Clock or negedge Resetn) begin
	if (Resetn == 1'b0) begin
			
		
		SRAM_address <= 18'd0;
		
						
	end else begin
		if (~VGA_enable) begin
			VGA_red <= 10'd0;
 			VGA_green <= 10'd0;
	   		VGA_blue <= 10'd0;								
		end else begin
			case (VGA_SRAM_state)
				S_M1_LEAD_1:begin
				end
				S_M1_LEAD_2:begin
				end
				S_M1_LEAD_3:begin
				end
				S_M1_LEAD_4:begin
				end
				S_M1_LEAD_5:begin
				end
				S_M1_LEAD_6:begin
				end
				S_M1_LEAD_7:begin
				end
				S_M1_LEAD_8:begin
				end
				S_M1_LEAD_9:begin
				end
				S_M1_LEAD_10:begin
				end
				S_M1_CC_1:begin
				end
				S_M1_CC_2:begin
				end
				S_M1_CC_3:begin
				end
				S_M1_CC_4:begin
				end
				S_M1_CC_5:begin
				end
				S_M1_UP_1:begin
				end
				S_M1_UP_2:begin
				end
				S_M1_UP_3:begin
				end
				S_M1_UP_4:begin
				end
				S_M1_UP_5:begin
				end
				S_M1_UP_6:begin
				end
				S_M1_UP_7:begin
				end
			default: VGA_SRAM_state <= S_VS_WAIT_NEW_PIXEL_ROW;
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