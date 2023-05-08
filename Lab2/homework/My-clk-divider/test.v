`include "my_clk_div.v"

module test;
    //construction of test module
    reg clk;
    initial begin
        clk <= 0;
    end

    reg reset;
    initial begin
        reset <= 0;
        @(posedge clk);
        reset <= 1;
        @(posedge clk);
        reset <= 0;

        repeat(2) begin
            #380
            reset <= 0;
            @(posedge clk);
            reset <= 1;
            @(posedge clk);
            reset <= 0;
        end
    end

    reg [7:0] divCountIn;
    initial begin
        divCountIn <= 8'd2;
        #400 divCountIn <= 8'd3;
        #400 divCountIn <= 8'd4;
    end

    always begin
        #10 clk <= ~clk;
    end

    //module itself
    wire div;
    my_clk_div my_clk_div1(reset, clk, divCountIn, div);

    //dump settings
    initial begin
        $monitor(reset,, clk,, divCountIn,, div);
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
    end

    initial begin
        #1200 $finish();
    end

endmodule
