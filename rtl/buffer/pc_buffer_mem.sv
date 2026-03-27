module pc_buffer_mem (
    input logic clk,
    input logic rst,
    input logic [31:0] i_pcM,
    output logic [31:0] o_pcM
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_pcM <= 32'b0;
    end else begin
      o_pcM <= i_pcM;
    end
end

endmodule