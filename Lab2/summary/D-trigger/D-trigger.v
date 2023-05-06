module d_trigger(
    input wire d, clk, aReset,
    output reg q
);

    always @(posedge clk or negedge aReset)
        if(~aReset) //сброс при aReset == 0
            q <= 1'b0;
        else
            q <= d; //значение берется из пред такта!!!
endmodule