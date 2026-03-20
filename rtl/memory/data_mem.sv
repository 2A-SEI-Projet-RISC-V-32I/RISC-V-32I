`define DATA_WIDTH 32

module data_memory #(
    parameter MEM_SIZE = 1024 
) (
    input wire i_clk,
    input wire i_we,
    input wire [3:0] i_be, 
    input wire [`DATA_WIDTH-1:0] i_data,
    input wire [$clog2(MEM_SIZE)-1:0] i_addr,
    output wire [`DATA_WIDTH-1:0] o_data
);
    
    reg [`DATA_WIDTH-1:0] memory [0:MEM_SIZE-1];
    integer i;

    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            memory[i] = 32'h00000000;
        end
    end

    always_ff @(posedge i_clk) begin
        if (i_we) begin

            if (i_be[0]) memory[i_addr][7:0]   <= i_data[7:0];
            if (i_be[1]) memory[i_addr][15:8]  <= i_data[15:8];
            if (i_be[2]) memory[i_addr][23:16] <= i_data[23:16];
            if (i_be[3]) memory[i_addr][31:24] <= i_data[31:24];
        end
    end

    assign o_data = memory[i_addr];

endmodule