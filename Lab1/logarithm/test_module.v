`include "logarithm.v"
`include "../decoder/decoder.v"

module test_module;

    reg [2:0] inValue;
    wire [7:0] midVector;
    wire [2:0] outValue;
    wire [2:0] outValue_better;

    //Если logarithm реализован правильно то inValue == outValue

    decoder decoder1(inValue, midVector);
    logarithm logarithm1(midVector, outValue);
    logarithm_better logarithm_better1(midVector, outValue_better);

    initial begin
        inValue = 4'b0;
    end

    always @(inValue)
        begin
            #5
            if((inValue  == outValue) && (inValue == outValue_better))
                $display("Success!");
            else
                $display("Jopa!",, inValue,, outValue,, outValue_better);
        end

    always
        begin
            #10 inValue = inValue + 1;
        end

    initial
        $monitor(inValue,, midVector,, outValue,, outValue_better);

    initial
        #300 $finish();

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test_module); //levels, top-module
    end

endmodule