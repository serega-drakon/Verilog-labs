module clk_div(
    input wire rst,
    input wire clk,
    output reg div2, div4, div8
);

    always @(posedge clk) begin

        if(rst)
            {div2, div4, div8} = 3'b000;
        else begin
            div2 = ~div2;
            div4 = (div2) ? ~div4 : div4;
            div8 = (div4 && div2) ? ~div8 : div8;
        end
    end

endmodule