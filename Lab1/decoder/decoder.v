module decoder(
    input wire [2:0] inNumber,
    output wire [7:0] outVector
);
    assign outVector = 8'b1 << inNumber;

endmodule