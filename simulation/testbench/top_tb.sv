module top_tb;
    reg clk;
    reg rst;

    top dut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;
        
        #20 rst = 0;

        $readmemh("simple.hex", mem);


        #10000; 
        $display("Timeout : Le programme est trop long ou bloqué !");
        $finish;
    end
endmodule