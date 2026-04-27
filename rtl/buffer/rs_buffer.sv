module rs_buffer(
    input logic clk,
    input logic rst,
    input logic i_en,
    input logic i_clr,
    input logic [31:0] i_rs,
    output logic [31:0] o_rs
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      o_rs <= 32'b0;
    end else begin 
        if (i_clr) begin
            o_rs <= 32'b0;
        end else if (i_en) begin 
            o_rs <= i_rs;
        end
    end
end

endmodule