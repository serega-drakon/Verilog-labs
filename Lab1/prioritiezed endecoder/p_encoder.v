module p_encoder (
    input wire [7:0] inVector,
    output reg [2:0] outNumber
);

    integer i;
    always @(inVector) begin
        outNumber = 7;
        for(i = 7; i > 0 && ~inVector[i]; i = i - 1) //подразумевается, что 1 когда нибудь встретится
            outNumber = i - 1;
    end
endmodule