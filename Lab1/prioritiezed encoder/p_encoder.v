module p_encoder_for(
    input wire [7:0] inVector,
    output reg [2:0] outNumber
);

    integer i; // надеюсь компилятор ее в итоге уберет
    always @(inVector) begin
        outNumber = 7;
        for(i = 7; i > 0 && ~inVector[i]; i = i - 1) //подразумевается, что 1 когда нибудь встретится
            outNumber = i - 1;
    end
endmodule

//наверное здесь подразумевалось что я нафигачу как черт 8 вложенных друг в друга ифов
//или сделаю версию с флагом и последовательными ифами, ща нафигачу без for (просто выше допускаю, что компилятор умный
//и сделает как я хочу чтобы оно в итоге было)

module p_encoder_gen_for(
    input wire [7:0] inVector,
    output reg [2:0] outNumber
);

    reg found;
    genvar i;
    generate for(i = 7; i >= 0; i = i - 1)
    always @(inVector)
    begin
        found = 0;
        begin : loop
            if(inVector[i] && ~found)
            begin
                outNumber <= i;
                    found <= 1;
            end
        end
    end
    endgenerate
endmodule

//ПОЧЕМУ У МЕНЯ ОТ МОИХ ВЫКЛАДОК КОМПИЛЯТОР ЗАВИСАЕТ!!! ! !!!! !? ??!???!?!??!!??!?!?!?!?!??!
//потому что не нужно делать вечные циклы, я в первый раз увидел как саморучно зациклил компилятор
//я даже на верилоге циклил командную строку, с каждым днем все новое дно

// ? куча вложенных друг в друга однотипных ифов ? -- рекурсия!
//СМОТРИТЕ ПРОДОЛЖЕНИЕ В ПАПКЕ /Lab1/recursive p encoder!!!!