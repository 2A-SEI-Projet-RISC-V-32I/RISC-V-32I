module pc (
    input logic clk,
    input logic rst,
    input logic [31:0] i_pc,
    output logic [31:0] o_pc
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_pc <= 32'b0;
    end else begin
      o_pc <= i_pc;
    end
end

endmodule