`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/20 04:06:21
// Design Name: 
// Module Name: exception
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


module exceptiondec(
	input  wire rst,
	input  wire [7:0] exception,
	input  wire laddrerror,
	input  wire saddrerror,
	input  wire [31:0] cp0status,
	input  wire [31:0] cp0cause,
	input  wire [31:0] cp0epc,
	output wire exceptionoccur,
	output reg  [31:0] exceptiontype,
	output reg  [31:0] pcexception
    );
	
	// exception type judge
	always @ (*)
	begin
		if (rst)
			exceptiontype <= 32'b0;
		else 
		begin
			if (((cp0cause[15:8] & cp0status[15:8]) != 8'h00) && !cp0status[1] && cp0status[0])
				exceptiontype <= 32'h0000_0001;
			else if (exception[7] || laddrerror)
				exceptiontype <= 32'h0000_0004;
			else if (saddrerror)
				exceptiontype <= 32'h0000_0005;
			else if (exception[6])
				exceptiontype <= 32'h0000_0008;
			else if (exception[5])
				exceptiontype <= 32'h0000_0009;
			else if (exception[4])
				exceptiontype <= 32'h0000_000e;
			else if (exception[3])
				exceptiontype <= 32'h0000_000a;
			else if (exception[2])
				exceptiontype <= 32'h0000_000c;
			else
				exceptiontype <= 32'h0000_0000;
		end
	end

	// pc when occur exception
	always @(*) 
	begin
		case (exceptiontype)
			32'h0000_0001: pcexception <= 32'hbfc0_0380;
			32'h0000_0004: pcexception <= 32'hbfc0_0380;
			32'h0000_0005: pcexception <= 32'hbfc0_0380;
			32'h0000_0008: pcexception <= 32'hbfc0_0380;
			32'h0000_0009: pcexception <= 32'hbfc0_0380;
			32'h0000_000a: pcexception <= 32'hbfc0_0380;
			32'h0000_000c: pcexception <= 32'hbfc0_0380;
			32'h0000_000d: pcexception <= 32'hbfc0_0380;
			32'h0000_000e: pcexception <= cp0epc;
			default: ;
		endcase
	end

	assign exceptionoccur = (exceptiontype);

endmodule
