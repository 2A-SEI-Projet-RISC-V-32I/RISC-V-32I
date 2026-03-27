module im__buffer_ex(
    input logic clk,
    input logic rst,
    input logic [31:0] i_instrE,
    output logic [31:0] o_instrE
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_instrE <= 32'b0;
    end else begin
      o_instrE <= i_instrE;
    end
end

endmodule