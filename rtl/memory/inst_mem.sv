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

    always @(*) begin
        inst = mem[addr];
    end

endmodule