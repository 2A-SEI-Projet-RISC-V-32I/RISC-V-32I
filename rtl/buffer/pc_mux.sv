module mux_pc (
    input logic [31:0] i_alu_out,
    input logic [31:0] i_pc_out,
    input logic br_true,
    output logic [31:0] o_data
);

always_comb
begin
        if (br_true) o_data = i_alu_out;
        else o_data = i_pc_out + 32'd4;
end

endmodule