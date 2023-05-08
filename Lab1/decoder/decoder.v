module decoder #(
    parameter BIN_SIZE = 3,
    parameter BOUT_SIZE = 8
)(
    input wire [BIN_SIZE - 1:0] inNumber,
    output wire [BOUT_SIZE - 1:0] outVector
);
    assign outVector = 1'b1 << inNumber;

endmodule