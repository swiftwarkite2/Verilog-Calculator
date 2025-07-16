`timescale 1ns / 1ps
//Ethan Brown
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 02:06:07 PM
// Design Name: 
// Module Name: Data_Memory_RAM
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


module Data_Memory_RAM(
input clock,
input [7:0]address,
input [7:0]data_in,
input write,
output reg [7:0]data_out
    );
reg [7:0] RW [128:223]; // define RAM array
reg EN;
 always @(address)
    begin
        if ((address >= 128) && (address <= 223))
            EN = 1'b1; // enable
        else
            EN = 1'b0; // disable
    end

 always @(posedge clock)
    begin
        if (write && EN)
            RW[address] = data_in; // write data into RAM
        else if (!write && EN)
            data_out = RW[address]; // read data from RAM
    end
endmodule
