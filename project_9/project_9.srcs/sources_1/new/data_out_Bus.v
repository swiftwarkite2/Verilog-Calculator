`timescale 1ns / 1ps
//Ethan Brown
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 02:12:42 PM
// Design Name: 
// Module Name: data_out_Bus
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


module data_out_Bus(
input [7:0]address,
input [7:0]rom_data,
input [7:0]rw_data,
input [7:0]port_in_00,
input [7:0]port_in_01,
output reg [7:0]data_out
    );
 always @(*)
    begin: MUX1
        if ((address >= 0) && (address <= 127))
            data_out = rom_data;
        else if ((address >= 128) && (address <= 223))
            data_out = rw_data;
        else if (address == 8'hF0) data_out = port_in_00;
        else if (address == 8'hF1) data_out = port_in_01;
 // add other input ports here
    end
endmodule
