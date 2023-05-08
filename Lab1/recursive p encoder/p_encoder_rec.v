`include "if_recursive_call.v"

module p_encoder_rec #(
    parameter BIN_SIZE = 8,
    parameter BOUT_SIZE = 3
)(
    input wire [BIN_SIZE - 1:0] inVector,
    output wire [BOUT_SIZE - 1:0] outNumber
);
    //пошло поехало...
    if_recursive_call #(.BOUT_SIZE(BOUT_SIZE),.i(BIN_SIZE - 1))
        if_rec_call1(.inVector(inVector),.inNumber({BOUT_SIZE{1'b0}}), .outNumber(outNumber));
endmodule


//это можно записать еще проще o_O
module p_encoder_no_rec #(
    parameter BIN_SIZE = 8,
    parameter BOUT_SIZE = 3
)(
    input wire [BIN_SIZE - 1:0] inVector,
    output wire [BOUT_SIZE - 1:0] outNumber
);

    wire [BOUT_SIZE - 1:0] outNumberMid [BIN_SIZE - 1:0];

    assign outNumberMid[BIN_SIZE - 1] = (inVector[BIN_SIZE - 1]) ? BIN_SIZE - 1: 0;

    genvar i;
    generate for(i = BIN_SIZE - 2; i >= 0; i = i - 1) begin : loop
        assign outNumberMid[i] = (inVector[i] && (outNumberMid[i + 1] == 0)) ? i : outNumberMid[i + 1];
    end
    endgenerate

    assign outNumber = outNumberMid[0];

endmodule
//хотя не так изящно и понтово выглядит // одно и то же но без рекурсии