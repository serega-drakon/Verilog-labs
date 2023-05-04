`include "odd_checker.v"

module test_module;

    reg [7:0] inNumber = 0;
    wire outValue;

    odd_checker odd_checker1(inNumber, outValue);

    always begin
        #10 inNumber = inNumber+ 1;
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test_module);
    end

    initial begin
        #500 $finish();
    end

    initial begin
        $monitor(inNumber,, outValue);
    end

endmodule