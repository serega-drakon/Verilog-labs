module logarithm (
    input wire [7:0] inVector,
    output reg [2:0] outNumber
);

    integer i;
    always @(inVector) begin
        outNumber = 0;
        for(i = 0; i < 7 && ~inVector[i]; i = i + 1) //подразумевается, что 1 когда нибудь встретится
            outNumber = i + 1;
    end
endmodule