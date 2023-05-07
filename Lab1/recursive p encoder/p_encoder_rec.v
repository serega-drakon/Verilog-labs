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