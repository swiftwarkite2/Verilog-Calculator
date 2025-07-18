`timescale 1ns / 1ps
// Ethan Brown
//////////////////////////////////////////////////////////////////////////////////
// within memory connects ROM, RAM, output ports, and data out Bus 
//////////////////////////////////////////////////////////////////////////////////

module memory( 
input [7:0]address,
input [7:0]data_in,
input write,
input [7:0]port_in_00,
input [7:0]port_in_01,
input clock,
input reset,
output [7:0]data_out,
output [7:0]port_out_00,
output [7:0]port_out_01
    );
wire [7:0]rom_data;
wire [7:0]rw_data;
Program_Memory_ROM U1(clock, address, rom_data);
Data_Memory_RAM U2(clock, address, data_in, write, rw_data);
Output_Ports U3(clock, address, reset, data_in, write, port_out_00, port_out_01);
data_out_Bus U4(address, rom_data, rw_data, port_in_00, port_in_01, data_out);
endmodule
