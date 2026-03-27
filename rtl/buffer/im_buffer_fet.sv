module im__buffer_fet(
    input logic clk,
    input logic rst,
    input logic [31:0] i_instrF,
    output logic [31:0] o_instrF
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_instrF <= 32'b0;
    end else begin
      o_instrF <= i_instrF;
    end
end

endmodule