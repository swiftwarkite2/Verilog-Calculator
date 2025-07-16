`timescale 1ns / 1ps
// Ethan Brown
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2024 03:20:54 PM
// Design Name: 
// Module Name: top
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


module top( // converts basys hardware to computer inputs and outputs
input [15:0]sw,
input btnU,
input clk,
output [15:0]led
    );
wire invert_btnU;
assign invert_btnU = !btnU;
computer U1(clk,invert_btnU,sw[7:0],sw[15:8],led[7:0],led[15:8]);
endmodule
