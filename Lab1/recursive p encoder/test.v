`include "p_encoder_rec.v"
`include "../decoder/decoder.v"

module test_module;

    reg [2:0] inValue;
    wire [7:0] midVector;
    reg [7:0] midVectorChanged;
    wire [2:0] outValue [1:0];

    //Если p_encoder реализован правильно но inValue == outValue

    decoder decoder1(inValue, midVector);

    always @(midVector)     //нарисую ка красивые лесенки!
        begin
            midVectorChanged = midVector;
            for(integer i = 0; i < inValue; i++)
                midVectorChanged = midVectorChanged | (1 << i);
        end     //остальные варианты перебирать лень, и так все понятно

    p_encoder_rec p_encoder_rec1(.inVector(midVectorChanged), .outNumber(outValue[0]));
    p_encoder_no_rec p_encoder_no_rec(.inVector(midVectorChanged), .outNumber(outValue[1]));

    initial begin
        inValue = 4'b0;
    end

    always @(inValue)
        begin
            #5
                if((inValue  == outValue[0]) && (inValue == outValue[1]))
                    $display("Success!");
                else
                    $display("Jopa!",, inValue,, outValue[0],, outValue[1]);
        end

    always
        begin
            #10 inValue = inValue + 1;
        end

    //dump
    initial
        $monitor(inValue,, midVector,, outValue[0],,outValue[1]);

    initial
        #300 $finish();

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test_module); //levels, top-module
    end

endmodule