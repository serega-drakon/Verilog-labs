module my_clk_div( //крутые челики сразу общий вариант делителя делают B)

    input wire rst,
    input wire clk,
    input wire [7:0] divCountIn,
    output reg div
);

    reg [7:0] divReg;
    reg [7:0] divCount;

    always @(clk) begin
        if(rst) begin
            divCount <= divCountIn;
            divReg <= 0;
            div <= 0;
        end
        else begin
            divReg = divReg + 1;
        end

        if(divReg == divCount) begin
            divReg = 0;
            div = ~div;
        end
    end

endmodule