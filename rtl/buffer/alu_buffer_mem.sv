module alu_buffer_mem(
    input logic clk,
    input logic rst,
    input logic [31:0] i_addrM,
    output logic [31:0] o_addrM
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_addrM <= 32'b0;
    end else begin
      o_addrM <= i_addrM;
    end
end

endmodule