module div_checker(
    input wire [7:0] inNumber,
    output wire outValue
);

    wire [2:0] count_odd;
    wire [2:0] count_even;

    assign count_odd = inNumber[0] + inNumber[2] + inNumber[4] + inNumber[6];
    assign count_even = inNumber[1] + inNumber[3] + inNumber[5] + inNumber[7];

    wire signed [4:0] reminder; //думаю ниче страшного если я использую signed
    //операция вычитания = операция сложения с поправкой на кодировку чисел
    assign reminder = count_odd - count_even;

    assign outValue = (reminder == (-3) || reminder == 0 || reminder == 3) ? 1 : 0;

endmodule


module div_checker_2(   //если пояснить чисто на языке проводов
    input wire [7:0] inNumber,
    output wire outValue
);

    //разбиваем 8 бит на 4 по 2 бита и считаем остатки (избавляюсь от 2'b11 = 3 тк неудобно)
    wire [1:0] reminder_1 [3:0];
    assign reminder_1[3] = (inNumber[7] && inNumber[6]) ? 2'b0 : inNumber[7:6];
    assign reminder_1[2] = (inNumber[5] && inNumber[4]) ? 2'b0 : inNumber[5:4];
    assign reminder_1[1] = (inNumber[3] && inNumber[2]) ? 2'b0 : inNumber[3:2];
    assign reminder_1[0] = (inNumber[1] && inNumber[0]) ? 2'b0 : inNumber[1:0];

    //затем обьединяем соседние пары и считаем остатки
    wire [1:0] reminder_2 [1:0];
    assign reminder_2[1] =
        ((reminder_1[3] ^ reminder_1[2]) == 2'b11) ? 2'b00 : //b11 же нет поэтому тут только комбинация b10 и b01
        (reminder_1[3][1] && reminder_1[2][1]) ? 2'b01 : reminder_1[3] + reminder_1[2]; //overflow

    assign reminder_2[0] =
        ((reminder_1[1] ^ reminder_1[0]) == 2'b11) ? 2'b00 :
            (reminder_1[1][1] && reminder_1[0][1]) ? 2'b01 : reminder_1[1] + reminder_1[0];

    //делаем то же самое, но уже теряем ненужную информацию
    assign outValue =
        ((reminder_2[1] + reminder_2[0] == 0) || (reminder_2[1] + reminder_2[0] == 3)) ? 1 : 0 ;

endmodule   //не стал запариваться с generate

//Мб можно так сэкономить на транзисторах, но я не считал
