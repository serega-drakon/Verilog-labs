module if_recursive_call #(
    parameter i = 7,
    parameter BOUT_SIZE = 3
)(
    input wire [i:0] inVector,
    input wire [BOUT_SIZE - 1:0] inNumber, //нужен для передачи данных в рекурсии
    output wire [BOUT_SIZE - 1:0] outNumberRec,
    output wire [BOUT_SIZE - 1:0] outNumber
);

    assign outNumberRec = (inVector[i] && (inNumber == 0)) ? i[BOUT_SIZE - 1 : 0] : inNumber;

    generate if(i > 0) begin : induction_step
        if_recursive_call #(.i(i - 1), .BOUT_SIZE(BOUT_SIZE))
            if_rec(.inVector(inVector[i - 1 : 0]), .inNumber(outNumberRec), .outNumber(outNumber));
    end
    else begin : induction_base
        assign outNumber = outNumberRec;
    end
    endgenerate

endmodule