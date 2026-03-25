module rs2_buffer_dec(
    input logic clk,
    input logic rst,
    input logic [31:0] i_rs2,
    output logic [31:0] o_rs2
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_rs2 <= 32'b0;
    end else begin
      o_rs2 <= i_rs2;
    end
end

endmodule