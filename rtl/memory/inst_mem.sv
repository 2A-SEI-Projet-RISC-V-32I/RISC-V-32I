`define INST_WIDTH 32

module instruction_memory #(
    parameter MEM_SIZE = 1024 
) (
    
    input wire clk,
    // L'adresse arrive sur 10 bits (log2(1024)) mais ca veut dire que les 32 bits du pc 
    //doivent etre transformé en 10 avant le bloc d'instruction memoire
    input wire [$clog2(MEM_SIZE)-1:0] addr, 
    // OUTPUT
    output reg [`INST_WIDTH-1:0] inst
);

    reg [`INST_WIDTH-1:0] mem [0:MEM_SIZE-1];

    integer i;

    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
            mem[i] = 32'h00000000;
        end

        mem[0] = 32'h00108113;
        mem[1] = 32'h00108193;
        mem[2] = 32'h00310233;
        mem[3] = 32'hfe218ae3;
        mem[4] = 32'h00000000;
    end

    always_comb begin
        inst = mem[addr];
    end

endmodule