module rd_buffer(
    input logic clk,
    input logic rst,
    input logic [31:0] rdata,   
    output logic [31:0] rd_buffer_out
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      rd_buffer_out <= 32'b0;
    end else begin
      rd_buffer_out <= rdata;
    end
  end
endmodule