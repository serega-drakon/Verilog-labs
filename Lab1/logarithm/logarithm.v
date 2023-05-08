module logarithm (  //это моя первая версия
    input wire [7:0] inVector,
    output reg [2:0] outNumber
);

    integer i; // яб хотел чтобы она пропала во время синтеза
    always @(inVector) begin
        outNumber = 0;
        for(i = 0; i < 7 && ~inVector[i]; i = i + 1) //подразумевается, что 1 когда нибудь встретится
            outNumber = i + 1;
    end
endmodule

module logarithm_better_old #(
    parameter BIN_SIZE = 8,
    parameter BOUT_SIZE = 3
)(
    input wire [BIN_SIZE - 1:0] inVector,
    output reg [BOUT_SIZE - 1:0] outNumber
);

    genvar i; //а вот эта пропадет
    generate for(i = 0; i < BIN_SIZE; i = i + 1)
    begin : loop
        always @(inVector)
            if(inVector[i])
                outNumber = i;
    end
    endgenerate

endmodule

module logarithm_better #( //Исправил
    parameter BIN_SIZE = 8,
    parameter BOUT_SIZE = 3
)(
    input wire [BIN_SIZE - 1:0] inVector,
    output wire [BOUT_SIZE - 1:0] outNumber
);

    wire [BOUT_SIZE - 1:0] midNumber [BIN_SIZE - 1:0];
    assign midNumber[0] = 0;

    genvar i;
    generate for(i = 1; i < BIN_SIZE; i = i + 1) begin : loop
        assign midNumber[i] = (inVector[i]) ? i[BOUT_SIZE - 1:0] : midNumber[i - 1];
    end
    endgenerate

    assign outNumber = midNumber[BIN_SIZE - 1];

endmodule