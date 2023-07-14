`include "fifo_shift.v"
module test;

    reg clk = 1;
    always #5 clk = ~clk;

    reg reset;
    reg rd_en;
    reg wr_en;
    reg [7 : 0] wr_data;
    wire [7 : 0] rd_data;
    wire wr_ready;
    wire rd_ready;
    wire rd_val;


    fifo_shift fifo1(clk, reset, rd_en, wr_en, wr_data, rd_data, wr_ready, rd_ready, rd_val);

    integer i;
    initial begin
        reset <= 1;
        wr_en <= 0;
        rd_en <= 0;
        #10 reset <= 0;
        wr_en <= 1;
        for(i = 8; i >= 0; i = i - 1) begin
            wr_data <= i;
            #10;
        end
        wr_en <= 0;
        rd_en <= 1;
        for(i = 0; i < 9; i = i + 1) begin
            #10;
        end
        #10 rd_en <= 0;

        #100;
        wr_en <= 1;
        rd_en <= 1;
        for(i = 9; i >= 1; i = i - 1) begin
            wr_data <= i;
            #10;
        end
        wr_en <= 0;
        rd_en <= 0;

        #100; //кусок от другого теста
        wr_en <= 1;
        rd_en <= 1;
        reset <= 1;
        wr_data = 8'b00000010;
        #10;
        wr_en <= 0;
        reset <= 0;
        #10 rd_en <= 0;
    end
    //dump settings
    initial begin
        $monitor(rd_data, " ", rd_val);
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(2, test);
    end

    initial begin
        #2000 $finish();
    end

endmodule