module alu_buffer(
    input logic clk,
    input logic rst,
    input logic [31:0] i_addr,
    output logic [31:0] o_addr
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_addr <= 32'b0;
    end else begin
      o_addr <= i_addr;
    end
end

endmodule