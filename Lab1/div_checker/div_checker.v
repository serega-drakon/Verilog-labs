`define odd 1'b0
`define even 1'b1
`define oddRmdr 1
`define evenRmdr 2

module div_checker(
    input wire [7:0] inNumber,
    output reg outValue
);

    integer i;
    reg [1:0] remainder;
    reg parity; // parity of power of two (0 - odd, 1 - even)
    always @(inNumber) begin
        remainder = 0;
        parity = `odd;
        // if odd remainder is 1 else (-1)
        for(i = 0; i < 8; i = i + 1) begin
            if(inNumber[i]) begin
                if(parity == `odd) begin
                    remainder = remainder + `oddRmdr;
                end
                else begin
                    if(remainder == 2)  // problem with overflow
                        remainder = 1;
                    else
                        remainder = remainder + `evenRmdr;
                end
                if(remainder == 3)
                    remainder = 0;
            end
            parity = ~parity;
        end

        if(remainder == 0)
            assign outValue = 1;
        else
            assign outValue = 0;
    end

endmodule

// хз мб там есть операция изьятия остатка из деления любых целых чисел,
// но мне показалось, что раз нам дана именно тройка то можно использовать
// математику для написания эффективного алгоритма, хоть он и может быть
// менее читаемым