`timescale 1ns / 1ps
// Ethan Brown
//////////////////////////////////////////////////////////////////////////////////
// converts basys hardware to computer inputs and outputs
//////////////////////////////////////////////////////////////////////////////////

module top( 
input [15:0]sw,
input btnU,
input clk,
output [15:0]led
    );
wire invert_btnU;
assign invert_btnU = !btnU;
computer U1(clk,invert_btnU,sw[7:0],sw[15:8],led[7:0],led[15:8]);
endmodule
