module my_clk_div #(
    parameter BIN_SIZE = 8
)(
    input wire rst,
    input wire clk,
    input wire [BIN_SIZE - 1:0] divCntInByTwo, // на вход частота в два раза меньше требуемой
    output reg div
);

    reg [BIN_SIZE - 1:0] divReg;
    reg [BIN_SIZE - 1:0] divCntByTwo;

    always @(posedge clk) begin
        if(rst) begin
            divCntByTwo <= divCntInByTwo;
            divReg <= 0;
            div <= 0;
        end
        else begin
            if(divReg + 1 == divCntByTwo) begin
                divReg <= 0;
                div <= ~div;
            end
            else
                divReg <= divReg + 1;
        end
    end

endmodule