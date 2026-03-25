module mux_2_inputs (
    input logic [31:0] i_data_1,
    input logic [31:0] i_data_0,
    input logic i_sel,
    output logic [31:0] o_data
);

always_comb
begin
        o_data = i_sel ? i_data1 : i_data2;
end

endmodule