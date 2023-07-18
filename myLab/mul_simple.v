module mul_simple #(    //алгоритм умножения столбиком
    parameter DATA_1_WIDTH = 8,
    parameter DATA_2_WIDTH = DATA_1_WIDTH,
    parameter RES_WIDTH = DATA_1_WIDTH + DATA_2_WIDTH
)(
    input wire [DATA_1_WIDTH - 1 : 0] first,
    input wire [DATA_2_WIDTH - 1 : 0] second,
    output wire [RES_WIDTH - 1 : 0] result
);
    wire [RES_WIDTH - 1 : 0] first_byte_extended;
    assign first_byte_extended = {{(RES_WIDTH - DATA_1_WIDTH){1'b0}}, first[DATA_1_WIDTH - 1 : 0]};

    wire [RES_WIDTH - 1 : 0] mul_by_digit [DATA_2_WIDTH - 1 : 0];
    genvar i;
    generate for(i = 0; i < DATA_2_WIDTH; i = i + 1) begin : loop_mul
        assign mul_by_digit[i] = (first_byte_extended << i) & {RES_WIDTH{second[i]}};
    end
    endgenerate

    wire [RES_WIDTH - 1 : 0] mid_data [DATA_2_WIDTH - 1 : 0];
    generate for(i = 0; i < DATA_2_WIDTH; i = i + 1) begin : loop_sum
        if(i == 0)
            assign mid_data[i] = mul_by_digit[i];
        else
            assign mid_data[i] = mid_data[i - 1] + mul_by_digit[i]; // сумматоры - опасно, могут возникать задержки
    end
    endgenerate

    assign result = mid_data[DATA_2_WIDTH - 1];

endmodule