module alu_buffer_ex (
    input logic clk,
    input logic rst,
    input logic [31:0] i_alu_buffer_ex,
    output logic [31:0] o_alu_buffer_ex
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_alu_buffer_ex <= 32'b0;
    end else begin
      o_alu_buffer_ex <= i_alu_buffer_ex;
    end
end

endmodule