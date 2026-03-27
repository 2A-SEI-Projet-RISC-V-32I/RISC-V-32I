module pc__buffer_dec(
    input logic clk,
    input logic rst,
    input logic [31:0] i_pcD,
    output logic [31:0] o_pcD
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_pcD <= 32'b0;
    end else begin
      o_pcD <= i_pcD;
    end
end

endmodule