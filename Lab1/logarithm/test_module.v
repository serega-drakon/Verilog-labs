module test_module;

    reg [2:0] inValue;
    wire [7:0] midVector;
    wire [2:0] outValue;

    //Если logarithm реализован правильно но inValue == outValue

    decoder decoder1(inValue, midVector);
    logarithm logarithm1(midVector, outValue);

    initial begin
        inValue = 4'b0;
    end

    always @(inValue)
        begin
            #5
            if(inValue  == outValue)
                $display("Success!");
            else
                $display("Jopa!",, inValue,, outValue);
        end

    always
        begin
            #10 inValue = inValue + 1;
        end

    initial
        $monitor(inValue,, midVector,, outValue);

    initial
        #300 $finish();

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test_module); //levels, top-module
    end

endmodule

module decoder(
    input wire [2:0] inNumber,
    output wire [7:0] outVector
);
    assign outVector = 8'b1 << inNumber;

endmodule