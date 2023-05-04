module odd_checker(
    input wire [7:0] inNumber,
    output wire outValue
);
    assign outValue = ~inNumber[0];
endmodule