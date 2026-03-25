module signext_buffer(
    input logic clk,
    input logic rst,
    input logic [31:0] i_immediate,
    output logic [31:0] o_immediate
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_immediate <= 32'b0;
    end else begin
      o_immediate <= i_immediate;
    end
end

endmodule