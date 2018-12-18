`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/15 01:43:13
// Design Name: 
// Module Name: memsel
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.vh"

module memsel(
	input  wire [31:0] pc,
	input  wire [5:0] op,
	input  wire [31:0] addr,
	input  wire [31:0] writedata,
	input  wire [31:0] readdata,
	output reg  [3:0] sel,
	output reg  [31:0] writedata2,
	output reg  [31:0] finaldata,
	output reg  [31:0] erroraddr,
	output reg  laddrerror,
	output reg  saddrerror
    );

	always @ (*) 
	begin
		erroraddr <= pc;
		saddrerror <= 1'b0;
		laddrerror <= 1'b0;
		writedata2 <= writedata;
		case (op)
			`LW,`LB,`LBU,`LH,`LHU: sel <= 4'b0000;
			`SW:
			begin 
				case (addr[1:0])
					2'b00: sel <= 4'b1111;
					default: 
					begin 
						saddrerror <= 1'b1;
						erroraddr <= addr;
						sel <= 4'b0000;
					end
				endcase
			end
			`SH:
			begin
				writedata2 <= {writedata[15:0],writedata[15:0]};
				case (addr[1:0])
					2'b10: sel <= 4'b1100;
					2'b00: sel <= 4'b0011;
					default:
					begin 
						saddrerror <= 1'b1;
						erroraddr <= addr;
						sel <= 4'b0000;
					end 
				endcase
			end
			`SB:
			begin
				writedata2 <= {writedata[7:0],writedata[7:0],writedata[7:0],writedata[7:0]};
				case (addr[1:0])
					2'b11: sel <= 4'b1000;
					2'b10: sel <= 4'b0100;
					2'b01: sel <= 4'b0010;
					2'b00: sel <= 4'b0001;
				endcase
			end
			default: sel <= 4'b0000;
		endcase
	end

	always @ (*)
	begin
		laddrerror <= 1'b0;
		case (op)
			`LW:
			begin 
				case (addr[1:0])
					2'b00: finaldata <= readdata;
					default: 
					begin 
						laddrerror <= 1'b1;
						erroraddr <= addr;
						sel <= 4'b0000;
					end
				endcase
			end
			`LH:
			begin 
				case (addr[1:0])
					2'b10: finaldata <= {{16{readdata[31]}},readdata[31:16]};
					2'b00: finaldata <= {{16{readdata[15]}},readdata[15:0]};
					default: 
					begin 
						laddrerror <= 1'b1;
						erroraddr <= addr;
						sel <= 4'b0000;
					end
				endcase
			end
			`LHU:
			begin 
				case (addr[1:0])
					2'b10: finaldata <= {{16{1'b0}},readdata[31:16]};
					2'b00: finaldata <= {{16{1'b0}},readdata[15:0]};
					default: 
					begin 
						laddrerror <= 1'b1;
						erroraddr <= addr;
						sel <= 4'b0000;
					end
				endcase
			end
			`LB:
			begin 
				case (addr[1:0])
					2'b11: finaldata <= {{24{readdata[31]}},readdata[31:24]};
					2'b10: finaldata <= {{24{readdata[23]}},readdata[23:16]};
					2'b01: finaldata <= {{24{readdata[15]}},readdata[15:8]};
					2'b00: finaldata <= {{24{readdata[7]}},readdata[7:0]};	        
				endcase
			end
			`LBU:
			begin 
				case (addr[1:0])
					2'b11: finaldata <= {{24{1'b0}},readdata[31:24]};
					2'b10: finaldata <= {{24{1'b0}},readdata[23:16]};
					2'b01: finaldata <= {{24{1'b0}},readdata[15:8]};
					2'b00: finaldata <= {{24{1'b0}},readdata[7:0]};
				endcase
			end
			default: finaldata <= `ZeroWord;
		endcase
	end

endmodule
