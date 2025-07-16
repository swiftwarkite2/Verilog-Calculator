`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 02:56:04 PM
// Design Name: 
// Module Name: memory_TB
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


module memory_TB(

    );
reg [7:0]address;
reg [7:0]data_in;
reg write;
reg [7:0]port_in_00;
reg [7:0]port_in_01;
reg clock;
reg reset;
wire [7:0]data_out;
wire [7:0]port_out_00;
wire [7:0]port_out_01;
memory DUT(address, data_in, write, port_in_00, port_in_01, clock, reset,data_out, port_out_00, port_out_01);
initial 
begin
clock = 0;
data_in = 6;
write = 1;
port_in_00 = 2;
port_in_01 = 3;
reset = 0;
address = 0;
#20;
address = 1;
#20;
address = 2;
#20;
address = 3;
#20;
address = 4;
#20;
address = 5;
#20;
address = 6;
#20;
address = 128;
#20;
write = 0;
#20;
address = 140;
data_in = 12;
write = 1;
#20;
write = 0;
#20;
address = 128;
#20;
address = 224;
write = 1;
reset = 1;
#20;
data_in = 18;
address = 225;
#20;
address = 226;
#20;
address = 240;
#20;
address = 241;
#20;
$finish();
end
always
    #10 clock = ~clock;            
endmodule
