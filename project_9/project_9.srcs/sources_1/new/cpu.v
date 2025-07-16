`timescale 1ns / 1ps
// Ethan Brown
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2024 02:52:47 PM
// Design Name: 
// Module Name: cpu
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


module cpu( // connects data path and control unit
input wire [7:0]from_memory,
input wire clock,
input wire reset,
output wire write,
output wire [7:0]to_memory,
output wire [7:0]address
    );
wire IR_Load;
wire [7:0]IR;
wire MAR_Load;
wire PC_Load;
wire PC_Inc;
wire A_Load;
wire B_Load;
wire [2:0]ALU_Sel;
wire [3:0]CCR_Result;
wire CCR_Load;
wire [1:0]Bus2_Sel;
wire [1:0]Bus1_Sel;
Data_Path U1(IR_Load,MAR_Load,PC_Load,PC_Inc,A_Load,B_Load,ALU_Sel,CCR_Load,Bus2_Sel,Bus1_Sel,from_memory,clock,reset,IR,CCR_Result,to_memory[7:0],address[7:0]);
Control_Unit U2(clock,reset,IR,CCR_Result,IR_Load,MAR_Load,PC_Load,PC_Inc,A_Load,B_Load,ALU_Sel,CCR_Load, Bus2_Sel,Bus1_Sel,write);
endmodule
