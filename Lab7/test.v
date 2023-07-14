`include "../Lab5/fifo_shift.v"
`include "../Lab6/fifo_cycle.v"

module test;

    reg clk = 1;
    always #5 clk = ~clk;

    reg reset;
    reg rd_en;
    reg wr_en;
    reg [7 : 0] wr_data;
    wire [7 : 0] rd_data_1;
    wire [7 : 0] rd_data_2;
    wire wr_ready_1;    // почему то в vcd файл не выводятся значения массивов
    wire rd_ready_1;
    wire rd_val_1;
    wire wr_ready_2;
    wire rd_ready_2;
    wire rd_val_2;

    fifo_shift fifo_shift(clk, reset, rd_en, wr_en, wr_data, rd_data_1, wr_ready_1, rd_ready_1, rd_val_1);
    fifo_cycle fifo_cycle(clk, reset, rd_en, wr_en, wr_data, rd_data_2, wr_ready_2, rd_ready_2, rd_val_2);

    integer unsigned i;
    integer unsigned j, k;
    integer status = 1;
    initial begin
        reset <= 1;
        wr_en <= 0;
        rd_en <= 0;
        #10 reset <= 0;
        for(i = 0; i < 999999999; i = i + 1) begin //не особо запариваюсь по константам, нахер это надо)
            #10;
            k <= $unsigned($random) % 16; //смотрим случай переполнения
            wr_en <= 1;
            for(j = 0; j < k; j = j + 1) begin
                wr_data <= $random;
                #10;
                if(wr_ready_1 != wr_ready_2 || rd_ready_1 != rd_ready_2) begin
                    status = 0;
                end
            end
            k <= $unsigned($random) % 16; //случай перечитывания
            wr_en <= 0;
            rd_en <= 1;
            for(j = 0; j < k; j = j + 1) begin
                #10;
                if((rd_data_1 != rd_data_2 && rd_ready_1 == 1 && rd_ready_2 == 1) // ну то есть на веревке валидные данные висят
                    || rd_val_1 != rd_val_2 || rd_ready_1 != rd_ready_2 || wr_ready_1 != wr_ready_2) begin //а тут понятно
                    status = 0;
                end
            end
            #10 rd_en <= 0;
        end
    end
    //dump settings
    initial begin
        $monitor(rd_data_1, " ", rd_data_1, " ", rd_val_1, " ", rd_val_2);
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars(2, test);
    end

    initial begin
        #2000000;
        if(status)
            $display("cock");
        else
            $display("dick");
        $finish();
    end

endmodule