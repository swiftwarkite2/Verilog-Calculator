`timescale 1ns / 1ps
// Ethan Brown
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module Data_Path(
input wire IR_Load,
input wire MAR_Load,
input wire PC_Load,
input wire PC_Inc,
input wire A_Load,
input wire B_Load,
input wire [2:0]ALU_Sel,
input wire CCR_Load,
input wire [1:0]Bus2_Sel,
input wire [1:0]Bus1_Sel,
input wire [7:0]from_memory,
input wire clock,
input wire reset,
output reg [7:0]IR,
output reg [3:0]CCR_Result,
output reg [7:0]to_memory,
output reg [7:0]address
    );
 reg [7:0]PC;
 reg [7:0]A;
 reg [7:0]B;
 reg [7:0]Bus1;
 reg [7:0]Bus2;
 wire [7:0]Result;
 reg [7:0]MAR;
 wire [3:0]NZVC;
     // All of the remaining lines of code came from "Introduction to logic circuits and logic design with Verilog”, 3rd edition by Brock J. LaMeres 
    // Bus1 Mux
 always @(Bus1_Sel,PC,A,B)
    begin: MUX_BUS1
        case(Bus1_Sel)
            2'b00 : Bus1 = PC;
            2'b01 : Bus1 = A;
            2'b10 : Bus1 = B;
            default : Bus1 = 8'hXX;
    endcase
 end

 // Bus2 Mux
 always @(Bus2_Sel,Result,Bus1,from_memory) // the textbook has ALU_Result instead of Result
    begin: MUX_BUS2
        case(Bus2_Sel)
            2'b00 : Bus2 = Result;
            2'b01 : Bus2 = Bus1;
            2'b10 : Bus2 = from_memory;
            default : Bus2 = 8'hXX; // the textbook has Bus1 instead of Bus2
    endcase
 end

 // assign to_memory and address outputs
 always @(Bus1,MAR)
    begin
        to_memory = Bus1;
        address = MAR;
    end

 // IR
 always @(posedge clock or negedge reset)
    begin: INSTRUCTION_REGISTER
        if (!reset)
            IR <= 8'h00;
        else
            if(IR_Load)
                IR <= Bus2;
    end

 // MAR
 always @(posedge clock or negedge reset)
    begin: MEMORY_ADDRESS_REGISTER
        if (!reset)
            MAR <= 8'h00;
        else
            if(MAR_Load)
                MAR <= Bus2;
    end

 // PC
 always @(posedge clock or negedge reset)
    begin: PROGRAM_COUNTER
        if (!reset)
            PC <= 8'h00;
        else
            if(PC_Load)
                PC <= Bus2;
            else if (PC_Inc)
                PC <= PC + 1; // the textbook has MAR instead of PC
    end

 // A
 always @(posedge clock or negedge reset)
    begin: A_REGISTER
        if (!reset)
            A <= 8'h00;
        else
            if(A_Load)
                A <= Bus2;
    end
 // B
 always @(posedge clock or negedge reset)
    begin: B_REGISTER
        if (!reset)
            B <= 8'h00;
    else
        if(B_Load)
            B <= Bus2;
    end

 // CCR
 always @(posedge clock or negedge reset)
    begin: CONDITION_CODE_REGISTER
        if (!reset)
            CCR_Result <= 4'h0; // textbook has 8’h00 instead of 4’h0
    else
        if(CCR_Load)
            CCR_Result <= NZVC;
    end
    ALU U1(ALU_Sel,B,Bus1,NZVC,Result); 
endmodule
