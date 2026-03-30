import definitions::*;

`define INST_WIDTH 32

module sign_ext (
    input wire [INST_WIDTH-1:0]    i_inst,
    input wire [OPCODE-1:0]        i_opcode,
    output reg [INST_WIDTH-1:0]    o_immediate_extended
);

always @*
begin
    case (i_opcode)
    OP_ALUI, OP_LOAD, OP_JALR: // Type I
    begin
        if (i_inst[31] == 1'b1)
        begin
            o_immediate_extended = {20'hFFFFF, i_inst[31:20]};
        end

        else

        begin
          o_immediate_extended = {20'h00000, i_inst[31:20]};
        end
    end

    OP_ALU:
    begin
        o_immediate_extended = 32'b0; // Pas d'immédiat, on force à zéro
    end

    OP_STORE: // Type S
    begin
        if (i_inst[31] == 1'b1)
        begin
            o_immediate_extended = {20'hFFFFF, i_inst[31:25], i_inst[11:7]};
        end

        else

        begin
          o_immediate_extended = {20'h00000, i_inst[31:25], i_inst[11:7]};
        end
    end

    OP_BRANCH: // Type B
    begin
        if (i_inst[31] == 1'b1)
        begin
            o_immediate_extended = {19'h7FFFF, i_inst[31], i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
        end

        else

        begin
          o_immediate_extended = {19'h00000, i_inst[31], i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
        end
    end

    OP_JAL: // Type J
    begin
        if (i_inst[31] == 1'b1)
        begin
            o_immediate_extended = {12'hFFF, i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0 };
        end

        else

        begin
            o_immediate_extended = {12'h000, i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0 };
        end
    end

    OP_AUIPC, OP_LUI: // Type U
    begin
        o_immediate_extended = {i_inst[31:12], 12'h000};
    end

    default:
    begin
        o_immediate_extended = 32'b0; 
    end

    endcase
end

endmodule
