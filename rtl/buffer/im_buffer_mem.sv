module im__buffer_mem(
    input logic clk,
    input logic rst,
    input logic [31:0] i_instrM,
    output logic [31:0] o_instrM
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_instrM <= 32'b0;
    end else begin
      o_instrM<= i_instrM;
    end
end

endmodule