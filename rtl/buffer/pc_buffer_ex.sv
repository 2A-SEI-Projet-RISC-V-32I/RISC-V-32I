module pc_buffer_ex (
    input logic clk,
    input logic rst,
    input logic [31:0] i_pcE,
    output logic [31:0] o_pcE
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_pcE <= 32'b0;
    end else begin
      o_pcE <= i_pcE;
    end
end

endmodule