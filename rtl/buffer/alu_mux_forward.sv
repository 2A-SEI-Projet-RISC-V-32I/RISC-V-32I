module alu_mux_forward (
    input  logic [31:0] i_rs_E,
    input  logic [31:0] i_alu_M,
    input  logic [31:0] i_wb,
    input  logic [1:0]  i_sel,
    output logic [31:0] o_rs_forward
);

always_comb begin
    case (i_sel)
        2'b00: o_rs_forward = i_rs_E;
        2'b10: o_rs_forward = i_alu_M;
        2'b01: o_rs_forward = i_wb;
        default: o_rs_forward = i_rs_E;
    endcase
end

endmodule
