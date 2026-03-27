module mux_3_inputs (
    input logic [31:0] pc,
    input logic [31:0] i_data_1,
    input logic [31:0] i_data_0,
    input logic [1:0] wb_sel,
    output logic [31:0] w_data
);

always_comb begin
    case (wb_sel)
      2'b00: w_data = i_data_0;
      2'b01: w_data = i_data_1;
      2'b10: w_data = pc + 32'd4;
      default: w_data = i_data_0;
    endcase
end

endmodule