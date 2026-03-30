import definitions::*;

module branch (
    // INPUT
    input wire i_branch,
    input wire [2:0] i_branch_op,
    input wire [DATA_WIDTH-1:0] i_a,
    input wire [DATA_WIDTH-1:0] i_b,
    // OUTPUT
    output reg o_take
);

    always_comb begin : branch
        o_take = 1'b0;
        if (i_branch) begin
        case(i_branch_op)  
            BRANCH_BEQ: o_take = i_a==i_b;
            BRANCH_BNE:o_take = i_a!=i_b;
            BRANCH_BLT: o_take = $signed(i_a) < $signed(i_b);
            BRANCH_BGE: o_take = $signed(i_a) >= $signed(i_b);
            BRANCH_BLTU: o_take = i_a < i_b;
            BRANCH_BGEU: o_take = i_a >= i_b;
            BRANCH_JAL_JALR: o_take = 1'b1;
            default : o_take = 1'b0;
        endcase
        end 
    end

endmodule
