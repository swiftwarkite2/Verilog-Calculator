`timescale 1ns / 1ps
//Ethan Brown
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module Output_Ports(
input clock,
input [7:0]address,
input reset,
input [7:0]data_in,
input write,
output reg [7:0]port_out_00,
output reg [7:0]port_out_01
    );
    // All of the remaining lines of code came from "Introduction to logic circuits and logic design with Verilog”, 3rd edition by Brock J. LaMeres 
    // port_out_00 (address E0)
 always @(posedge clock or negedge reset)
    begin
        if (!reset)
            port_out_00 <= 8'h00;
        else
            if ((address == 8'hE0) && (write))
                port_out_00 <= data_in;
    end
 // port_out_01 (address E1)
 always @(posedge clock or negedge reset)
    begin
        if (!reset)
            port_out_01 <= 8'h00;
    else
        if ((address == 8'hE1) && (write))
            port_out_01 <= data_in;
    end

 // add other output ports here
endmodule
