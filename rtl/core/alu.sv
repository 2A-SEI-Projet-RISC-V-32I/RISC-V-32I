`define DATA_WIDTH 32

// RISC-V ALU Operations
`define OP_ALU_ADD    6'b011001 // Add ; Computes the sum of two input values
`define OP_ALU_SUB    6'b011011 // Subtract ; Calculates the difference between two input values
`define OP_ALU_AND    6'b011101 // Bitwise AND ; Performs a bitwise AND operation on the input values
`define OP_ALU_OR     6'b011111 // Bitwise OR ; Executes a bitwise OR operation on the input values
`define OP_ALU_XOR    6'b100001 // Bitwise XOR ; Conducts a bitwise XOR operation on the input values
`define OP_ALU_SLT    6'b100011 // Set Less Than (signed) ; Evaluates if the first input value is less than the second, returning a boolean result
`define OP_ALU_SLTU   6'b100101 // Set Less Than (unsigned) ; Compares two unsigned values to determine if the first is less than the second
`define OP_ALU_SLL    6'b100111 // Shift Left Logical ; Shift Left Logical: Shifts the bits of the first input value to the left, filling with zeros
`define OP_ALU_SRL    6'b101001 // Shift Right Logical ; Shifts the bits of the first input value to the right, filling with zeros
`define OP_ALU_SRA    6'b101011 // Shift Right Arithmetic ; Shifts the bits of the first input value to the right, preserving the sign bit

module alu (
    // INPUT
    input wire [5:0] i_alu_op,
    input wire [`DATA_WIDTH-1:0] i_a,
    input wire [`DATA_WIDTH-1:0] i_b,
    // OUTPUT
    output reg [`DATA_WIDTH-1:0] o_c
);

always @(*) begin
        case (i_alu_op)
            `OP_ALU_ADD : o_c = i_a + i_b;
            `OP_ALU_SUB : o_c = i_a - i_b;
            `OP_ALU_AND : o_c = i_a & i_b;
            `OP_ALU_OR  : o_c = i_a | i_b;
            `OP_ALU_XOR : o_c = i_a ^ i_b;
            `OP_ALU_SLT : o_c = ($signed(i_a) < $signed(i_b)) ? 32'b1 : 32'b0;
            `OP_ALU_SLTU: o_c = (i_a < i_b) ? 32'b1 : 32'b0;
            `OP_ALU_SLL : o_c = i_a << i_b[4:0];
            `OP_ALU_SRL : o_c = i_a >> i_b[4:0];
            `OP_ALU_SRA : o_c = $signed(i_a) >>> i_b[4:0];

            default: o_c = 32'b0;
        endcase
end

endmodule