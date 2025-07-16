`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2024 01:21:47 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
input wire [2:0]ALU_Sel,
input wire [7:0]In1,
input wire [7:0]In2,
output reg [3:0]NZVC,
output reg [7:0]Result
    );
    // ALU
 always @(In1,In2,ALU_Sel)
    begin
        case(ALU_Sel)
            3'b000 : begin // Addition
                {NZVC[0],Result} = In1 + In2; // Sum and Carry Flag

                NZVC[3] = Result[7]; // Negative Flag

                // Zero Flag
                if (Result == 0)
                    NZVC[2] = 1;
                else
                    NZVC[2] = 0;

                // Two's Comp Overflow Flag
                if ((In1[7] == 0) && (In2[7] == 0) && (Result[7] == 1) ||
                    (In1[7] == 1) && (In2[7] == 1) && (Result[7] == 0))
                        NZVC[1] = 1;
                else
                    NZVC[1] = 0;
            end
            
            3'b001 : begin // Subtraction
                {NZVC[0],Result} = In2 - In1; // Sum and Carry Flag

                NZVC[3] = Result[7]; // Negative Flag

                // Zero Flag
                if (Result == 0)
                    NZVC[2] = 1;
                else
                    NZVC[2] = 0;

                // Two's Comp Overflow Flag
                if ((In1[7] == 0) && (In2[7] == 0) && (Result[7] == 1) ||
                    (In1[7] == 1) && (In2[7] == 1) && (Result[7] == 0))
                        NZVC[1] = 1;
                else
                    NZVC[1] = 0;
            end
            
            3'b010 : begin // Multiplication
                {NZVC[0],Result} = In2 * In1; // Sum and Carry Flag

                NZVC[3] = Result[7]; // Negative Flag

                // Zero Flag
                if (Result == 0)
                    NZVC[2] = 1;
                else
                    NZVC[2] = 0;

                // Two's Comp Overflow Flag
                if ((In1[7] == 0) && (In2[7] == 0) && (Result[7] == 1) ||
                    (In1[7] == 1) && (In2[7] == 1) && (Result[7] == 0))
                        NZVC[1] = 1;
                else
                    NZVC[1] = 0;
            end
            
            3'b011 : begin // Division
                {NZVC[0],Result} = In2 / In1; // Sum and Carry Flag

                NZVC[3] = Result[7]; // Negative Flag

                // Zero Flag
                if (Result == 0)
                    NZVC[2] = 1;
                else
                    NZVC[2] = 0;

                // Two's Comp Overflow Flag
                if ((In1[7] == 0) && (In2[7] == 0) && (Result[7] == 1) ||
                    (In1[7] == 1) && (In2[7] == 1) && (Result[7] == 0))
                        NZVC[1] = 1;
                else
                    NZVC[1] = 0;
            end

                // add other ALU operations here

        default : begin
                Result = 8'hXX;
                NZVC = 4'hX;
            end
        endcase

    end
endmodule
