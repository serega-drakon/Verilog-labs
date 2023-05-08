`include "p_encoder_simple.v"
`include "../decoder/decoder.v"

module test_module;

    reg [2:0] inValue;
    wire [7:0] midVector;
    reg [7:0] midVectorChanged;
    wire [2:0] outValue;

    //Если p_encoder реализован правильно но inValue == outValue

    decoder decoder1(inValue, midVector);

    always @(midVector)     //нарисую ка красивые лесенки!
        begin
            midVectorChanged = midVector;
            for(integer i = 0; i < inValue; i++)
                midVectorChanged = midVectorChanged | (1 << i);
        end     //остальные варианты перебирать лень, и так все понятно

    p_encoder_simple p_encoder_simple1(.inVector(midVectorChanged), .outNumber(outValue));

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

    //dump
    initial
        $monitor(inValue,, midVector,, outValue);

    initial
        #300 $finish();

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test_module); //levels, top-module
    end

endmodule