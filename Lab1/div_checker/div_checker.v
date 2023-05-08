module div_checker(
    input wire [7:0] inNumber,
    output wire outValue
);

    wire [2:0] count_odd;
    wire [2:0] count_even;

    assign count_odd = inNumber[0] + inNumber[2] + inNumber[4] + inNumber[6];
    assign count_even = inNumber[1] + inNumber[3] + inNumber[5] + inNumber[7];

    wire  [4:0] reminder;

    assign reminder = count_odd + 2 * count_even;

    assign outValue = (reminder == 0 || reminder == 3 || reminder == 6 || reminder == 9 || reminder == 12) ? 1 : 0;

endmodule