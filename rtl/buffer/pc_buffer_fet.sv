module pc_buffer_fet (
    input logic clk,
    input logic rst,
    input logic [31:0] i_pcF,
    output logic [31:0] o_pcF
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_pcF <= 32'b0;
    end else begin
      o_pcF <= i_pcF;
    end
end

endmodule