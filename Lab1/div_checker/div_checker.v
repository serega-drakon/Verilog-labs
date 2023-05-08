`define oddRmdr 1
`define evenRmdr 2

module div_checker(
    input wire [7:0] inNumber,
    output wire outValue
);

    reg [1:0] remainder;
    genvar i;
    generate for(i = 0; i < 8; i = i + 1)
    always @(inNumber) begin
        remainder = 0;
        // if odd remainder is 1 else (-1)
         begin : loop
            if(inNumber[i]) begin
                if(i % 2  == 0) begin : odd
                    remainder = remainder + `oddRmdr;
                end
                else begin : even
                    if(remainder == 2)  // problem with overflow
                        remainder = 1;
                    else
                        remainder = remainder + `evenRmdr;
                end
                if(remainder == 3)
                    remainder = 0;
            end
        end
    end
    endgenerate

    assign outValue = (remainder == 0) ? 1 : 0;

endmodule

// хз мб там есть операция изьятия остатка из деления любых целых чисел,
// но мне показалось, что раз нам дана именно тройка то можно использовать
// математику для написания эффективного алгоритма, хоть он и может быть
// менее читаемым