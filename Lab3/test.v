`include "memory_module.v"

module test;

    reg clk = 0;
    always #5 clk = ~clk;

    reg rd_en = 0;
    reg [5 : 0] rd_addr;
    reg wr_en = 0;
    reg [5 : 0] wr_addr;
    reg [7 : 0] wr_data;
    wire [7 : 0] rd_data;

    memory_module mem1(clk, rd_en, rd_addr, wr_en, wr_addr, wr_data, rd_data);

    integer i;
    initial begin
        wr_en <= 1;
        for(i = 0; i < 64; i = i + 1) begin
            #10 wr_addr <= i;
            wr_data <= i;
        end
        wr_en <= 0; //значение на 0x3F не запишется! да и фиг с ним, посмотрю чо будет
        rd_en <= 1;
        for(i = 0; i < 64; i = i + 1) begin
            rd_addr <= i;
            #10;
        end
        #10
        rd_en <= 0;
    end

    /*initial begin
        wr_en <= 1;
        wr_addr <= 0;
        wr_data <= 0;
        #10
        rd_addr <= 0;
        rd_en <= 1;
        wr_data <= 1;
    end
*/

    //dump settings
    initial begin
        $monitor(rd_data);
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0, test);
    end

    initial begin
        #2000 $finish();
    end

endmodule