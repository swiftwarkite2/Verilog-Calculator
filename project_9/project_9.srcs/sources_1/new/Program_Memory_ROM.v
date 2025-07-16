`timescale 1ns / 1ps
//Ethan Brown
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2024 02:02:34 PM
// Design Name: 
// Module Name: Program_Memory_ROM
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


module Program_Memory_ROM(
input clock,
input [7:0]address,
output reg [7:0]data_out
    );
reg EN;
// Define mnemonics for instruction set
 parameter LDA_IMM = 8'h86; // Load Register A with Immediate Addressing
 parameter LDA_DIR = 8'h87; // Load Register A with Direct Addressing
 parameter LDB_IMM = 8'h88; // Load Register B with Immediate Addressing
 parameter LDB_DIR = 8'h89; // Load Register B with Direct Addressing
 parameter STA_DIR = 8'h96; // Store Register A to memory (RAM or IO)
 parameter STB_DIR = 8'h97; // Store Register B to memory (RAM or IO)
 parameter ADD_AB = 8'h42; // A <= A + B
 parameter SUB_AB = 8'h43; // A <= A - B
 parameter AND_AB = 8'h44; // A <= A and B
 parameter OR_AB = 8'h45; // A <= A or B
 parameter INCA = 8'h46; // A <= A + 1
 parameter INCB = 8'h47; // B <= B + 1
 parameter DECA = 8'h48; // A <= A - 1
 parameter DECB = 8'h49; // B <= B - 1
 parameter MUL_AB = 8'h50; // A <= A * B
 parameter DIV_AB = 8'h51; // A <= A / B
 parameter BRA = 8'h20; // Branch Always
 parameter BMI = 8'h21; // Branch if N=1
 parameter BPL = 8'h22; // Branch if N=0
 parameter BEQ = 8'h23; // Branch if Z=1
 parameter BNE = 8'h24; // Branch if Z=0
 parameter BVS = 8'h25; // Branch if V=1
 parameter BVC = 8'h26; // Branch if V=0
 parameter BCS = 8'h27; // Branch if C=1
 parameter BCC = 8'h28; // Branch if C=0
 reg [7:0] ROM [0:127]; // define ROM array
 // store the program starting at address 0
 initial
 begin
// ROM[0] = LDB_DIR;
// ROM[1] = 8'hF1;
// ROM[2] = LDA_DIR;
// ROM[3] = 8'hF0;
// ROM[4] = ADD_AB;
// ROM[5] = BMI;
// ROM[6] = 8'h0B;
// ROM[7] = STA_DIR;
// ROM[8] = 8'hE0;
// ROM[9] = BRA;
// ROM[10] = 8'h00;
// ROM[11] = ADD_AB;
// ROM[12] = STA_DIR;
// ROM[13] = 8'hE0;
// ROM[14] = BRA;
// ROM[15] = 8'h00;
//ROM[0] = LDA_IMM;
//ROM[1] = 8'hAA;
//ROM[2] = STA_DIR;
//ROM[3] = 8'hE0;
//ROM[4] = BRA;
//ROM[5] = 8'h00;
 ROM[0] = LDA_DIR; //checks selector bits to see if it should do divide
 ROM[1] = 8'hF1;
 ROM[2] = LDB_IMM;
 ROM[3] = 8'h40;
 ROM[4] = ADD_AB;
 ROM[5] = BMI;
 ROM[6] = 8'h1E;
 
 ROM[7] = LDA_DIR; // checks to go to multiply
 ROM[8] = 8'hF1;
 ROM[9] = LDB_IMM;
 ROM[10] = 8'h80;
 ROM[11] = ADD_AB;
 ROM[12] = BMI;
 ROM[13] = 8'h25;
 
 ROM[14] = LDA_DIR; // checks to go to subtraction
 ROM[15] = 8'hF1;
 ROM[16] = LDB_IMM;
 ROM[17] = 8'hC0;
 ROM[18] = ADD_AB;
 ROM[19] = BMI;
 ROM[20] = 8'h2C;
 
 ROM[21] = LDA_DIR; // does the addition
 ROM[22] = 8'hF1;
 ROM[23] = LDB_DIR;
 ROM[24] = 8'hF0;
 ROM[25] = ADD_AB;
 ROM[26] = STA_DIR;
 ROM[27] = 8'hE0;
 ROM[28] = BRA;
 ROM[29] = 8'h00;
 
 ROM[30] = LDB_DIR;// does the division
 ROM[31] = 8'hF0;
 ROM[32] = DIV_AB;
 ROM[33] = STA_DIR;
 ROM[34] = 8'hE0;
 ROM[35] = BRA;
 ROM[36] = 8'h00;
 
 ROM[37] = LDB_DIR;// does the multiplication
 ROM[38] = 8'hF0;
 ROM[39] = MUL_AB;
 ROM[40] = STA_DIR;
 ROM[41] = 8'hE0;
 ROM[42] = BRA;
 ROM[43] = 8'h00;
 
 ROM[44] = LDB_DIR;// does the subtraction
 ROM[45] = 8'hF0;
 ROM[46] = SUB_AB;
 ROM[47] = STA_DIR;
 ROM[48] = 8'hE0;
 ROM[49] = BRA;
 ROM[50] = 8'h00;
 
 end
    always @(address)
        begin
            if ((address >= 0) && (address <= 127))
                EN = 1'b1; // enable
            else
                EN = 1'b0; // disable
        end

    always @(posedge clock)
        begin
            if (EN)
                data_out = ROM[address]; // read data from ROM
        end
endmodule
