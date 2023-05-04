`include "div_checker.v"

module test_module;

    reg [7:0] inNumber = 0;
    wire outValue;

    always begin
        #10 inNumber = inNumber+ 1;
    end

    div_checker div_checker1(inNumber, outValue);

    integer i = 0;
    always @(inNumber) begin //перебор остатков деления на 3
        #5
        if((i == 0 && outValue) || (i != 0 && ~outValue)) $display("Success!");
        else $display("Jopa!");
        i = i + 1;
        if(i == 3) i = 0;
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