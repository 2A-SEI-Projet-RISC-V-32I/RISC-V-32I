module im__buffer_ex(
    input logic clk,
    input logic rst,
    input logic [31:0] i_instruction,
    output logic [31:0] o_instruction
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_instruction <= 32'b0;
    end else begin
      o_instruction <= i_instruction;
    end
end

endmodule