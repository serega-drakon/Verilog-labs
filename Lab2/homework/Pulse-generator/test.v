`include "pulse_gen.v"

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

    reg [7:0] countIn;
    initial begin
        countIn <= 8'd2;
        #400 countIn <= 8'd3;
        #400 countIn <= 8'd4;
    end

    always begin
        #10 clk <= ~clk;
    end

    //module itself
    wire out;
    pulse_gen pulse_gen1(reset, clk, countIn, out);

    //dump settings
    initial begin
        $monitor(reset,, clk,, countIn,, out);
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(1, test, pulse_gen1);
    end

    initial begin
        #1200 $finish();
    end

endmodule
