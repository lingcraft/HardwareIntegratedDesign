`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/31 20:49:49
// Design Name: 
// Module Name: aludec
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

module aludec(
	input  wire [5:0] funct,
	input  wire [3:0] aluop,
	output reg  [4:0] alucontrol
    );
	
	always @ (*)
	begin
		case (aluop)
			`R_TYPE_OP:
			begin
				case (funct)
					// 逻辑运算
					`AND:	alucontrol <= `AND_CONTROL;
					`OR:	alucontrol <= `OR_CONTROL;
					`XOR:	alucontrol <= `XOR_CONTROL;
					`NOR:	alucontrol <= `NOR_CONTROL;

					// 移位
					`SLL:	alucontrol <= `SLL_CONTROL;
					`SRL:	alucontrol <= `SRL_CONTROL;
					`SRA:	alucontrol <= `SRA_CONTROL;
					`SLLV:	alucontrol <= `SLLV_CONTROL;
					`SRLV:	alucontrol <= `SRLV_CONTROL;
					`SRAV:	alucontrol <= `SRAV_CONTROL;

					// 数据移动
					`MFHI:	alucontrol <= `MFHI_CONTROL;
					`MFLO:	alucontrol <= `MFLO_CONTROL;
					`MTHI:	alucontrol <= `MTHI_CONTROL;
					`MTLO:	alucontrol <= `MTLO_CONTROL;

					// 算数运算
					`ADD:	alucontrol <= `ADD_CONTROL;
					`ADDU:	alucontrol <= `ADDU_CONTROL;
					`SUB:	alucontrol <= `SUB_CONTROL;
					`SUBU:	alucontrol <= `SUBU_CONTROL;
					`SLT:	alucontrol <= `SLT_CONTROL;
					`SLTU:	alucontrol <= `SLTU_CONTROL;
					`MULT:	alucontrol <= `MULT_CONTROL;
					`MULTU:	alucontrol <= `MULTU_CONTROL;
					`DIV:	alucontrol <= `DIV_CONTROL;
					`DIVU:	alucontrol <= `DIVU_CONTROL;

					default: alucontrol <= 5'b0;
				endcase
			end

			// 逻辑运算(I型)
			`ANDI_OP:  alucontrol <= `AND_CONTROL;
			`ORI_OP:   alucontrol <= `OR_CONTROL;
			`XORI_OP:  alucontrol <= `XOR_CONTROL;
			`LUI_OP:   alucontrol <= `LUI_CONTROL;

			// 算术运算(I型)
			`ADDI_OP:  alucontrol <= `ADD_CONTROL;
			`ADDIU_OP: alucontrol <= `ADD_CONTROL;
			`SLTI_OP:  alucontrol <= `SLT_CONTROL;
			`SLTIU_OP: alucontrol <= `SLTU_CONTROL;

			// 访存
			`MEM_OP:   alucontrol <= `ADD_CONTROL;

			// 特权
			`MFC0_OP:  alucontrol <= `MFC0_CONTROL;
			`MTC0_OP:  alucontrol <= `MTC0_CONTROL;

			//
			`MAX_OP:   alucontrol <= `MAX_CONTROL;
			
			default: alucontrol <= 5'b0;
		endcase
	end

endmodule
