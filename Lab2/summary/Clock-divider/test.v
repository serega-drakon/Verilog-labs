`include "clk_div.v"

module test;
    //construction of test module
    reg clk;
    initial begin
        clk <= 0;
    end

    reg reset;
    initial begin
        reset <= 0;
    end

    always begin
        #10 clk = ~clk;
    end

    initial begin
        @(posedge clk);
        reset <= 1;
        repeat(3) @(posedge clk);
        reset <= 0;
    end

    //module itself
    wire div2, div4, div8;
    clk_div clk_div1(reset, clk, div2, div4, div8);

    //dump settings
    initial begin
        $monitor(reset,, clk,, div2,, div4,, div8);
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
    end

    initial begin
        #500 $finish();
    end

endmodule
