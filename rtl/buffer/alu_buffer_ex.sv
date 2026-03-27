module alu_buffer_ex(
    input logic clk,
    input logic rst,
    input logic [31:0] i_addrE,
    output logic [31:0] o_addrE
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_addrE <= 32'b0;
    end else begin
      o_addrE <= i_addrE;
    end
end

endmodule