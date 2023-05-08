module pulse_gen#(
    parameter BIN_SIZE = 8
)(
    input wire rst,
    input wire clk,
    input wire [7:0] countInByTwo, // на вход частота в два раза меньше требуемой
    output wire out
);

    reg [BIN_SIZE - 1:0] num; // эт кол-во отсчитанных тактов
    reg [BIN_SIZE - 1:0] countByTwo;
    assign out = (num == 0) ? 1 : 0;

    always @(posedge clk) begin
        if(rst) begin
            countByTwo <= countInByTwo;
            num <= 0;
        end
        else begin
            if(num + 1 == countByTwo) begin
                num <= 0;
            end
            else
                num <= num + 1;
        end


    end

endmodule