module rs1_buffer_dec(
    input logic clk,
    input logic rst,
    input logic [31:0] i_rs1,
    output logic [31:0] o_rs1
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_rs1 <= 32'b0;
    end else begin
      o_rs1 <= i_rs1;
    end
end

endmodule