`timescale 1ns / 1ps
//Ethan Brown
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module Data_Memory_RAM(
input clock,
input [7:0]address,
input [7:0]data_in,
input write,
output reg [7:0]data_out
    );
// All of the remaining lines of code came from "Introduction to logic circuits and logic design with Verilog”, 3rd edition by Brock J. LaMeres 
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
