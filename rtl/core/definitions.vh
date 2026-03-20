`ifndef DEFINITIONS_VH
`define DEFINITIONS_VH

// Width definitions
`define DATA_WIDTH 32   // Data width in bits
`define ADDR_WIDTH 32   // Address width in bits
`define INST_WIDTH 32
`define NUM_REGISTER 32

// Memory size
//`define MEM_SIZE (1 << `ADDR_WIDTH) // Total number of memory locations

`define FUNCT_7 7

// RISC-V Base Instruction Set Opcodes
`define OPCODE 7
`define OP_LUI     7'b0110111 // Load Upper Immediate
`define OP_AUIPC   7'b0010111 // Add Upper Immediate to PC
`define OP_JAL     7'b1101111 // Jump and Link
`define OP_JALR    7'b1100111 // Jump and Link Register
`define OP_BRANCH  7'b1100011 // Branch Instructions (BEQ, BNE, BLT, etc.)
`define OP_LOAD    7'b0000011 // Load Instructions (LB, LH, LW, LBU, LHU)
`define OP_STORE   7'b0100011 // Store Instructions (SB, SH, SW)
`define OP_ALU     7'b0110011 // ALU Instructions (ADD, SUB, AND, OR, XOR, etc.)
`define OP_ALUI    7'b0010011 // ALU Immediate Instructions (ADDI, ANDI, ORI, XORI, etc.)
`define OP_FENCE   7'b0001111 // Fence
`define OP_SYSTEM  7'b1110011 // System Instructions (ECALL, EBREAK, etc.)

// RISC-V LOAD FUNCT 3
`define FUNCT_3_ALU_LB 3'b000  // Load Byte
`define FUNCT_3_ALU_LH 3'b001 // Load Half
`define FUNCT_3_ALU_LW3 3'b010  // Load Word
`define FUNCT_3_ALU_LBU 3'b100 // Load Byte Unsigned
`define FUNCT_3_ALU_LHU 3'b101  // Load Half Unsigned

// RISC-V STORE FUNCT 3
`define FUNCT_3_ALU_SB 3'b000 // Store Byte
`define FUNCT_3_ALU_SH 3'b001  // Store Half
`define FUNCT_3_ALU_SW3'b010 // Store Word

// System Instructions
`define OP_ALU_ECALL  6'b111000 // System Call
`define OP_ALU_EBREAK 6'b111001 // Debug Break
`define OP_ALU_FENCE  6'b111010 
`define OP_ALU_FENCEI 6'b111011

// RISC-V ALU Operations
`define OP_ALU_NOP    6'b000000 
`define OP_ALU_ADD    6'b011001 // Add
`define OP_ALU_SUB    6'b011011 // Subtract
`define OP_ALU_AND    6'b011101 // Bitwise AND
`define OP_ALU_OR     6'b011111 // Bitwise OR
`define OP_ALU_XOR    6'b100001 // Bitwise XOR
`define OP_ALU_SLT    6'b100011 // Set Less Than (signed)
`define OP_ALU_SLTU   6'b100101 // Set Less Than (unsigned)
`define OP_ALU_SLL    6'b100111 // Shift Left Logical
`define OP_ALU_SRL    6'b101001 // Shift Right Logical
`define OP_ALU_SRA    6'b101011 // Shift Right Arithmetic

// RISC-V BRANCH
`define BRANCH_BEQ    3'b000 // Branch Equal
`define BRANCH_BNE    3'b001 // Branch Not Equal
`define BRANCH_BLT    3'b100 // Branch Less Than
`define BRANCH_BGE    3'b101 // Branch Greater Than Or Equal
`define BRANCH_BLTU    3'b110 // Branch Less Than Unsigned
`define BRANCH_BGEU    3'b111 // Branch Greater Than Or Equal Unsigned

`define BRANCH_JAL_JALR 3'b010

// Other constants or parameters can be defined here

`endif