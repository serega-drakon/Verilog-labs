module test_reset; //syncronous reset

    reg clk;

    initial clk = 0;

    always #1 clk = ~clk;

    reg reset;
    initial begin
        @(posedge clk);
        reset = 1;
        repeat (3) @(negedge clk);
        reset = 0;
    end

endmodule