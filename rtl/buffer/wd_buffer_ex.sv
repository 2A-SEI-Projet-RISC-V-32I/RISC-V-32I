module wd_buffer_ex(
    input logic clk,
    input logic rst,
    input logic [31:0] i_data,
    output logic [31:0] o_data
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_data <= 32'b0;
    end else begin
      o_data <= i_data;
    end
end

endmodule