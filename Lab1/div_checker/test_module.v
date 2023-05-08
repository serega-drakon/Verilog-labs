`include "div_checker.v"

module test_module;

    reg [7:0] inNumber = 0;
    wire outValue;

    always begin
        #10 inNumber = inNumber + 1;
    end

    //для теста заменить модуль на требуемый
    div_checker_2 div_checker1(inNumber, outValue);

    integer status = 0;
    always @(inNumber) begin //перебор остатков деления на 3
        #5
        if(((inNumber % 3 == 0) && (outValue)) || ((inNumber % 3 != 0) && (!outValue)))
            $display("Success!");
        else begin
            $display("Jopa!");
            status = -1;
        end
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test_module);
    end

    initial begin
        #3000
        if(status == -1)
            $display("There are errors!!!");
        else if(status == 0)
            $display("норм");
        $finish();
    end

    initial begin
        $monitor(inNumber,, outValue);
    end


endmodule