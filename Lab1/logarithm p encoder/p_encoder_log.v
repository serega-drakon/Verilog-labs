`include "../logarithm/logarithm.v"

module p_encoder_log #(   //п. дешифратор с использованием модуля логарифма
    parameter BIN_SIZE = 8,
    parameter BOUT_SIZE = 3
)(
    input wire [BIN_SIZE - 1:0] inVector,
    output wire [BOUT_SIZE - 1:0] outNumber
);

    wire [BIN_SIZE - 1 : 0] midVector;
    wire oleG [BIN_SIZE - 1 : 0];

    assign midVector [BIN_SIZE - 1] = inVector [BIN_SIZE - 1];
    assign oleG [BIN_SIZE - 1] = midVector [BIN_SIZE - 1]; //oleG для связи, мол 1 была найдена

    genvar i;
    generate for(i = BIN_SIZE - 2; i >= 0; i = i - 1) begin : za_loop
        assign midVector [i] = (~oleG[i + 1]) ? inVector[i] : 0;
        assign oleG [i] = (oleG[i + 1]) ? oleG[i + 1] : midVector[i];
    end
    endgenerate

    logarithm_better #(.BIN_SIZE(BIN_SIZE), .BOUT_SIZE(BOUT_SIZE))
        log(.inVector(midVector), .outNumber(outNumber));

endmodule
//балдеж

//а что если отвлечся и применить свойство знака "=" для регистров? СМ В ПАПКУ p_encoder_simple