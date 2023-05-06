module d_latch (
    input wire D, C,
    output reg Q
);

    always @*
        if(C == 1)
            Q <= D;

endmodule