`include "mul_simple.v"

module test;

    reg clk = 1;
    always #5 clk = ~clk;

    localparam DATA_1_WIDTH = 8;
    localparam DATA_2_WIDTH = 4;
    localparam RES_WIDTH = 2 * DATA_1_WIDTH;

    reg [DATA_1_WIDTH - 1 : 0] first_byte;
    reg [DATA_2_WIDTH - 1 : 0] second_byte;
    wire [RES_WIDTH - 1 : 0] result;

    mul_simple #(DATA_1_WIDTH, DATA_2_WIDTH, RES_WIDTH) mul_simple1 (first_byte, second_byte, result);

    wire [RES_WIDTH - 1 : 0] first_byte_extended;
    wire [RES_WIDTH - 1 : 0] second_byte_extended;
    assign first_byte_extended = {{(RES_WIDTH - DATA_1_WIDTH){1'b0}}, first_byte[DATA_1_WIDTH - 1 : 0]};
    assign second_byte_extended = {{(RES_WIDTH - DATA_2_WIDTH){1'b0}}, second_byte[DATA_2_WIDTH - 1 : 0]};

    always begin
        #10 first_byte <= $random;
        second_byte <= $random;
        if(result != first_byte_extended * second_byte_extended)
            $display("pizda! ", first_byte, " ", second_byte, " ", result, " ", first_byte_extended * second_byte_extended);
    end

    //dump settings
    initial begin
        $monitor(first_byte, " ", second_byte, " ", result,);
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(2, test);
    end

    initial begin
        #20000 $finish();
    end

endmodule