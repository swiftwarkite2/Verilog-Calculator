`timescale 1ns / 1ps
// Ethan Brown
//////////////////////////////////////////////////////////////////////////////////
// connects memory and cpu
//////////////////////////////////////////////////////////////////////////////////

module computer( 
input wire clock,
input wire reset,
input wire [7:0]port_in_00,
input wire [7:0]port_in_01,
output wire [7:0]port_out_00,
output wire [7:0]port_out_01
    );
wire [7:0]from_memory;
wire [7:0]to_memory;
wire [7:0]address;
wire write;
memory U1(address[7:0],to_memory[7:0],write,port_in_00[7:0],port_in_01[7:0],clock,reset,from_memory[7:0],port_out_00[7:0],port_out_01[7:0]);
cpu U2(from_memory[7:0],clock,reset,write,to_memory[7:0],address[7:0]);
endmodule
