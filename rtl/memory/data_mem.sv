`define DATA_WIDTH 32

module data_memory #(
    // MEM_SIZE in Words (1024 * 4)
    parameter MEM_SIZE = 1024
) (
    input wire i_clk,
    input wire i_we,
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

        memory[1] = 32'h00000001;
        memory[2] = 32'h00000002;
        memory[3] = 32'h00000003;
        memory[4] = 32'h00000004;
    end

    always_ff @(posedge i_clk) begin

    if (i_we == 1'b1)
    begin
        memory[i_addr >> 2] <= i_data;
    end
    end

    assign o_data = memory[i_addr >> 2];

endmodule