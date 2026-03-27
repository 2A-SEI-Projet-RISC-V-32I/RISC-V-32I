module wb_mux (
    input logic [31:0] pc,
    input logic [31:0] i_data_1,
    input logic [31:0] i_data_0,
    input logic [1:0] wb_sel,
    output logic [31:0] o_data
);

always_comb begin
    case (wb_sel)
      2'b00: o_data = i_data_0;
      2'b10: o_data = i_data_1;
      2'b01: o_data = pc + 32'd4;
      default: o_data = i_data_0;
    endcase
end

endmodule