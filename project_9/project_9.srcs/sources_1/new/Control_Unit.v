`timescale 1ns / 1ps
// Ethan Brown
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////

module Control_Unit(
input wire clock,
input wire reset,
input wire [7:0]IR,
input wire [3:0]CCR_Result,
output reg IR_Load,
output reg MAR_Load,
output reg PC_Load,
output reg PC_Inc,
output reg A_Load,
output reg B_Load,
output reg [2:0]ALU_Sel,
output reg CCR_Load,
output reg [1:0]Bus2_Sel,
output reg [1:0]Bus1_Sel,
output reg write
    );
    // lines 25-69 of code came from "Introduction to logic circuits and logic design with Verilog”, 3rd edition by Brock J. LaMeres
    reg [7:0] current_state, next_state;

 parameter S_FETCH_0 = 0, // Opcode fetch states
    S_FETCH_1 = 1,
    S_FETCH_2 = 2,

    S_DECODE_3 = 3, // Opcode decode state

    S_LDA_IMM_4 = 4, // Load A (Immediate) states
    S_LDA_IMM_5 = 5,
    S_LDA_IMM_6 = 6,

    S_LDA_DIR_4 = 7, // Load A (Direct) states
    S_LDA_DIR_5 = 8,
    S_LDA_DIR_6 = 9,
    S_LDA_DIR_7 = 10,
    S_LDA_DIR_8 = 11,

    S_STA_DIR_4 = 12, // Store A (Direct) states
    S_STA_DIR_5 = 13,
    S_STA_DIR_6 = 14,
    S_STA_DIR_7 = 15,

    S_LDB_IMM_4 = 16, // Load B (Immediate) states
    S_LDB_IMM_5 = 17,
    S_LDB_IMM_6 = 18,

    S_LDB_DIR_4 = 19, // Load B (Direct) states
    S_LDB_DIR_5 = 20,
    S_LDB_DIR_6 = 21,
    S_LDB_DIR_7 = 22,
    S_LDB_DIR_8 = 23,

    S_STB_DIR_4 = 24, // Store B (Direct) states
    S_STB_DIR_5 = 25,
    S_STB_DIR_6 = 26,
    S_STB_DIR_7 = 27,

    S_BRA_4 = 28, // Branch Always States
    S_BRA_5 = 29,
    S_BRA_6 = 30,
    S_BEQ_4 = 31, // Branch if Equal States
    S_BEQ_5 = 32,
    S_BEQ_6 = 33,
    S_ADD_AB_4 = 34, // Add B to A
    S_SUB_AB_4 = 35, // Subtract B from A
    S_BMI_4 = 36, // started with actual BMI using a negative bit but it was not working so I changed to using overflow bit
                    // so branch if C=0 like BCC but did not change the name of the parameter so they still all called BMI
    S_BMI_5 = 37,
    S_BMI_6 = 38,
    S_BMI_7 = 39,
    S_MUL_AB_4 = 50, // Multiply A by B
    S_DIV_AB_4 = 51; // Divide A by B
 // lines 79-132 of code came from "Introduction to logic circuits and logic design with Verilog”, 3rd edition by Brock J. LaMeres   
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

    // add states for additional instructions here
    // state memory block
    always @(posedge clock or negedge reset)
        begin: STATE_MEMORY
            if (!reset)
                current_state <= S_FETCH_0;
            else
                current_state <= next_state;
        end
    // next state logic block
    always @(current_state, IR, CCR_Result)
        begin: NEXT_STATE_LOGIC
            case(current_state)
                S_FETCH_0 : next_state = S_FETCH_1; // Path for FETCH instruction
                S_FETCH_1 : next_state = S_FETCH_2;
                S_FETCH_2 : next_state = S_DECODE_3;

                S_DECODE_3 : 
//                    if (IR == LDA_IMM) next_state = S_LDA_IMM_4; // Register A was having issues with too many commands breaking so i had to comment
                                                                        // out the commands i was not using so the code would function
//                    else if (IR == LDA_DIR) next_state = S_LDA_DIR_4; 
                    if (IR == LDA_DIR) next_state = S_LDA_DIR_4;
                    else if (IR == STA_DIR) next_state = S_STA_DIR_4;
                    else if (IR == LDB_IMM) next_state = S_LDB_IMM_4; // Register B
                    else if (IR == LDB_DIR) next_state = S_LDB_DIR_4;
//                    else if (IR == STB_DIR) next_state = S_STB_DIR_4;
                    else if (IR == BRA) next_state = S_BRA_4; // Branch Always
                    else if (IR == ADD_AB) next_state = S_ADD_AB_4; // Add
                    else if (IR == SUB_AB) next_state = S_SUB_AB_4; // Sub
                    else if (IR == MUL_AB) next_state = S_MUL_AB_4; // Mul
                    else if (IR == DIV_AB) next_state = S_DIV_AB_4; // Div
                    else if (IR == BMI && CCR_Result[0] == 1) next_state = S_BMI_4; // Branch if C = 0
                    //else if (IR == BMI && CCR_Result == 0) next_state = S_BMI_7; // Do nothing if N = 0
                // lines 139-142 of code came from "Introduction to logic circuits and logic design with Verilog”, 3rd edition by Brock J. LaMeres
                    else next_state = S_FETCH_0; // others go here
                S_LDA_IMM_4 : next_state = S_LDA_IMM_5; // Path for All instruction
                S_LDA_IMM_5 : next_state = S_LDA_IMM_6;
                S_LDA_IMM_6 : next_state = S_FETCH_0;
                S_LDA_DIR_4 : next_state = S_LDA_DIR_5;
                S_LDA_DIR_5 : next_state = S_LDA_DIR_6;
                S_LDA_DIR_6 : next_state = S_LDA_DIR_7;
                S_LDA_DIR_7 : next_state = S_LDA_DIR_8;
                S_LDA_DIR_8 : next_state = S_FETCH_0;
                S_STA_DIR_4 : next_state = S_STA_DIR_5;
                S_STA_DIR_5 : next_state = S_STA_DIR_6;
                S_STA_DIR_6 : next_state = S_STA_DIR_7;
                S_STA_DIR_7 : next_state = S_FETCH_0;
                S_LDB_IMM_4 : next_state = S_LDB_IMM_5;
                S_LDB_IMM_5 : next_state = S_LDB_IMM_6;
                S_LDB_IMM_6 : next_state = S_FETCH_0;
                S_LDB_DIR_4 : next_state = S_LDB_DIR_5;
                S_LDB_DIR_5 : next_state = S_LDB_DIR_6;
                S_LDB_DIR_6 : next_state = S_LDB_DIR_7;
                S_LDB_DIR_7 : next_state = S_LDB_DIR_8;
                S_LDB_DIR_8 : next_state = S_FETCH_0;
                S_BRA_4 : next_state = S_BRA_5;
                S_BRA_5 : next_state = S_BRA_6;
                S_BRA_6 : next_state = S_FETCH_0;
                S_ADD_AB_4 : next_state = S_FETCH_0;
                S_SUB_AB_4 : next_state = S_FETCH_0;
                S_MUL_AB_4 : next_state = S_FETCH_0;
                S_DIV_AB_4 : next_state = S_FETCH_0;
                S_BMI_4 : next_state = S_BMI_5;
                S_BMI_5 : next_state = S_BMI_6;
                S_BMI_6 : next_state = S_FETCH_0;
                S_BMI_7 : next_state = S_FETCH_0;

        // Add next state logic for other states here
        // Add a default statement to handle unknown states
        // lines 175-207 of code came from "Introduction to logic circuits and logic design with Verilog”, 3rd edition by Brock J. LaMeres
        endcase
    end
    // Output logic block
    always @(current_state)
        begin: OUTPUT_LOGIC
            case(current_state)
                S_FETCH_0 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 1;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b01; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end

                S_FETCH_1 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 1;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_FETCH_2 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 1;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b10; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDA_IMM_4 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 1;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b01; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDA_IMM_5 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 1;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDA_IMM_6 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 1;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b10; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_STA_DIR_4 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 1;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b01; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_STA_DIR_5 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 1;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_STA_DIR_6 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 1;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b10; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_STA_DIR_7 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b01; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 1;
                end
                
                S_BRA_4 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 1;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b01; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_BRA_5 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_BRA_6 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 1;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b10; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_ADD_AB_4 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 1;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 1;
                    Bus1_Sel = 2'b01; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDB_IMM_4 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 1;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b01; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDB_IMM_5 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 1;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDB_IMM_6 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 1;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b10; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDA_DIR_4 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 1;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b01; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDA_DIR_5 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 1;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDA_DIR_6 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 1;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b10; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDA_DIR_7 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDA_DIR_8 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 1;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b10; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDB_DIR_4 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 1;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b01; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDB_DIR_5 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 1;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDB_DIR_6 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 1;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b10; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDB_DIR_7 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_LDB_DIR_8 : begin // Increment PC, Opcode will be available next state
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 1;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b10; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_SUB_AB_4 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 1;
                    B_Load = 0;
                    ALU_Sel = 3'b001;
                    CCR_Load = 1;
                    Bus1_Sel = 2'b01; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_MUL_AB_4 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 1;
                    B_Load = 0;
                    ALU_Sel = 3'b010;
                    CCR_Load = 1;
                    Bus1_Sel = 2'b01; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_DIV_AB_4 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 1;
                    B_Load = 0;
                    ALU_Sel = 3'b011;
                    CCR_Load = 1;
                    Bus1_Sel = 2'b01; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_BMI_4 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 1;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b01; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_BMI_5 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_BMI_6 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 1;
                    PC_Inc = 0;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b10; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end
                
                S_BMI_7 : begin // Put PC into MAR to provide address of Opcode
                    IR_Load = 0;
                    MAR_Load = 0;
                    PC_Load = 0;
                    PC_Inc = 1;
                    A_Load = 0;
                    B_Load = 0;
                    ALU_Sel = 3'b000;
                    CCR_Load = 0;
                    Bus1_Sel = 2'b00; // 00=PC, 01=A, 10=B
                    Bus2_Sel = 2'b00; // 00=ALU, 01=Bus1, 10=from_memory
                    write = 0;
                end

        // add Output logic for other states here

        // Add a default statement to handle unknown states
        endcase
    end
endmodule
