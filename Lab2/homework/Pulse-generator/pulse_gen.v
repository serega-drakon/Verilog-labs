module pulse_gen(

    input wire rst,
    input wire clk,
    input wire [7:0] countIn,
    output wire out
);

    reg [7:0] num;  //я не придумал как его назвать лучше... // эт кол-во отсчитанных тактов
    reg [7:0] count;
    assign out = (num == 0) ? 1 : 0;

    always @(clk) begin
        if(rst) begin
            count = countIn;
            num = 0;
        end
        else begin
            num = num + 1;
        end

        if(num == count) begin
            num = 0;
        end
    end

endmodule