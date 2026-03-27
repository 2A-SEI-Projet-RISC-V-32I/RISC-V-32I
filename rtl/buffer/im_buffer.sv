module im__buffer(
    input logic clk,
    input logic rst,
    input logic [31:0] i_instr,
    output logic [31:0] o_instr
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_instr <= 32'b0;
    end else begin
      o_instr <= i_instr;
    end
end

endmodule