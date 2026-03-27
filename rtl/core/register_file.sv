import definitions::*;

module register_file (
	// INPUT
    input wire i_clk,
    input wire i_rst,
    input wire i_we,
	input wire [DATA_WIDTH-1:0] i_rd,
    input wire [$clog2(NUM_REGISTER)-1:0] i_rd_addr,
    input wire [$clog2(NUM_REGISTER)-1:0] i_rs1_addr,     
    input wire [$clog2(NUM_REGISTER)-1:0] i_rs2_addr,
	// OUTPUT
    output wire [DATA_WIDTH-1:0] o_rs1,     
    output wire [DATA_WIDTH-1:0] o_rs2
);

logic [DATA_WIDTH-1:0] registers[0:NUM_REGISTER-1];

assign o_rs1 = (i_rs1_addr == 0) ? 32'b0 : registers[i_rs1_addr];
assign o_rs2 = (i_rs2_addr == 0) ? 32'b0 : registers[i_rs2_addr];

always_ff @( posedge i_clk ) begin
        if (i_rst) begin
            for (int i = 0; i < NUM_REGISTER; i = i + 1) begin
            registers[i] <= 32'b0;
            end
        end else begin
            if (i_we && (i_rd_addr != 0)) begin
                registers[i_rd_addr] <= i_rd;
            end
        end
end

endmodule
