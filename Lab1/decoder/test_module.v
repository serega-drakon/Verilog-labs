`include "decoder.v"

module test_module;

    reg [2:0] inValue;
    wire [7:0] outValue;

    decoder decoder1(inValue, outValue);

    always
    begin
    #10 inValue = inValue + 1;
    end

    initial begin
        inValue = 4'b0;
    end

    initial
        $monitor(inValue,, outValue);

    initial
        #300 $finish();

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test_module); //levels, top-module
    end

endmodule