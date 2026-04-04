import definitions::*;

module inst_mem #(
    parameter MEM_SIZE = 1024 
) (
    
    input wire clk,
    // L'adresse arrive sur 10 bits (log2(1024)) mais ca veut dire que les 32 bits du pc 
    //doivent etre transformé en 10 avant le bloc d'instruction memoire
    input wire [$clog2(MEM_SIZE)-1:0] addr, 
    // OUTPUT
    output reg [INST_WIDTH-1:0] inst
);

    reg [INST_WIDTH-1:0] mem [0:MEM_SIZE-1];

    integer i;

    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1) begin
             mem[i] = 32'h00000000;
        end

    // Pour le top_tb (à commenter ou non en fonction)

    $readmemh("../../programs/bin/inst.hex", mem);

    // Pour le inst_mem_tb (à commenter ou non en fonction)

    //mem[0] = 32'h00a00293;


    end

    always_comb begin
        inst = mem[addr];
    end

endmodule
