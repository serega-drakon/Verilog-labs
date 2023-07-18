`include "mul.v"

module test;

    reg clk = 1;
    always #5 clk = ~clk;

    localparam DATA_WIDTH = 32;
    localparam RES_WIDTH = DATA_WIDTH * 2;
    localparam PART_DATA_WIDTH = 8;

    reg reset;
    reg rd_en;
    reg wr_en;
    reg [DATA_WIDTH - 1 : 0] wr_data_1;
    reg [DATA_WIDTH - 1 : 0] wr_data_2;
    wire [RES_WIDTH - 1 : 0] rd_data;
    wire wr_ready;
    wire rd_ready;
    wire rd_val;

    mul #(.DATA_WIDTH(DATA_WIDTH), .RES_WIDTH(RES_WIDTH), .PART_DATA_WIDTH(PART_DATA_WIDTH))
        mul1 (clk, reset, rd_en, wr_en, wr_data_1, wr_data_2, rd_data, wr_ready, rd_ready, rd_val);

    initial begin
        wr_en <= 0;
        rd_en <= 0;
        reset <= 1;
        #10 reset <= 0;
        wr_en <= 1;
        wr_data_1 <= 32'h123456;
        wr_data_2 <= 32'h123456;
        #10 wr_en <= 0;
        while (~rd_ready) #10;
        rd_en <= 1;
        #20 rd_en <= 0;
    end
    //dump settings
    initial begin
        $monitor(rd_data, " ", rd_ready, " ", rd_val);
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(2, test);
    end

    initial begin
        #2000 $finish();
    end

endmodule