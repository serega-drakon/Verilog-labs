module p_encoder_simple #( // p_encoder с использованием свойства знака = для регистров
    parameter BIN_SIZE = 8,
    parameter BOUT_SIZE = 3
)(
    input wire [BIN_SIZE - 1:0] inVector,
    output reg [BOUT_SIZE - 1:0] outNumber //тута теперь регистр
);

    genvar i;
    generate for(i = 0; i < BIN_SIZE; i = i + 1)
    always @(inVector)
        begin
            outNumber = 0;
            begin : loop
                if(inVector[i] && outNumber < i) //ищем максимум :))
                    outNumber = i;               //произвольность исполнения не мешает!!!
            end                                  //требуется лишь чтобы приравнивались не одновременно
        end
    endgenerate

endmodule