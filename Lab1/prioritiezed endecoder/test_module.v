`include "p_encoder.v"
`include "../decoder/decoder.v"

module test_module;

    reg [2:0] inValue;
    wire [7:0] midVector;
    reg [7:0] midVectorChanged;
    wire [2:0] outValue;
    wire [2:0] outValueSecond;

    //Если p_encoder реализован правильно но inValue == outValue

    decoder decoder1(inValue, midVector);

    always @(midVector)     //нарисую ка красивые лесенки!
        begin
            midVectorChanged = midVector;
            for(integer i = 0; i < inValue; i++)
                midVectorChanged = midVectorChanged | (1 << i);
        end     //остальные варианты перебирать лень, и так все понятно

    p_encoder p_encoder1(midVectorChanged, outValue);
    p_encoder_second p_encoder_second1(midVectorChanged, outValueSecond);

    initial begin
        inValue = 4'b0;
    end

    always @(inValue)
        begin
            #5
            if((inValue  == outValue) && (inValue == outValueSecond))
                $display("Success!");
            else
                $display("Jopa!",, inValue,, outValue,,outValueSecond);
        end

    always
        begin
            #10 inValue = inValue + 1;
        end

    initial
        $monitor(inValue,, midVector,, outValue,,outValueSecond);

    initial
        #300 $finish();

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test_module); //levels, top-module
    end

endmodule