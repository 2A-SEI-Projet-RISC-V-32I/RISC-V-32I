`define DATA_WIDTH 32

`define BRANCH_BEQ      3'b000 // Branch Equal
`define BRANCH_BNE      3'b001 // Branch Not Equal
`define BRANCH_BLT      3'b100 // Branch Less Than
`define BRANCH_BGE      3'b101 // Branch Greater Than Or Equal
`define BRANCH_BLTU     3'b110 // Branch Less Than Unsigned
`define BRANCH_BGEU     3'b111 // Branch Greater Than Or Equal Unsigned
`define BRANCH_JAL_JALR 3'b010 // Jump in case of JAL or JALR instrucion

module branch_unit (
    // INPUT
    input wire i_branch,
    input wire [2:0] i_branch_op,
    input wire [`DATA_WIDTH-1:0] i_a,
    input wire [`DATA_WIDTH-1:0] i_b,
    // OUTPUT
    output reg o_take

    always_comb begin : i_branch_op
        o_take = 1'b0;
        if (i_branch) begin
        case(i_branch_op)  
            `BRANCH_BEQ: o_take = i_a==i_b;
            `BRANCH_BNE:o_take = i_a!=i_b;
            `BRANCH_BLT: o_take = $signed(i_a) < $signed(i_b);
            `BRANCH_BGE: o_take = $signed(i_a) >= $signed(i_b);
            `BRANCH_BLTU: o_take = i_a < i_b;
            `BRANCH_BGEU: o_take = i_a >= i_b;
            `BRANCH_JAL_JALR: o_take = 1'b1;
            default : o_take = 1'b0;
        endcase
        end 
    end
);

endmodule