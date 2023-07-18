`include "mul_simple.v"

module mul #( //unsigned случай
    parameter DATA_WIDTH = 32,
    parameter RES_WIDTH = DATA_WIDTH * 2,
    parameter PART_DATA_WIDTH = 8 //размер кусочков, на которые разобьем второй операнд в произведении
)(
    input wire clk,
    input wire reset,
    input wire rd_en,
    input wire wr_en,
    input wire [DATA_WIDTH - 1 : 0] wr_data_1,  //чет нельзя массивом, icarus требует "SystemVerilog support"
    input wire [DATA_WIDTH - 1 : 0] wr_data_2,
    output wire [RES_WIDTH - 1 : 0] rd_data,
    output reg wr_ready,
    output reg rd_ready,
    output reg rd_val
);
    reg [DATA_WIDTH - 1 : 0] wr_data_1_save;
    reg [DATA_WIDTH - 1 : 0] wr_data_2_save;
    reg [RES_WIDTH - 1 : 0] result;

    localparam EXT_WIDTH = DATA_WIDTH + DATA_WIDTH % PART_DATA_WIDTH;
    wire [EXT_WIDTH - 1 : 0] wr_data_2_save_extended;
    generate if(EXT_WIDTH == DATA_WIDTH) begin : gen_if_ext
        assign wr_data_2_save_extended = wr_data_2_save;
    end
    else begin
        assign wr_data_2_save_extended = {{(EXT_WIDTH - DATA_WIDTH){1'b0}}, wr_data_2_save[DATA_WIDTH - 1 : 0]};
    end //возможно не стоило так перебарщивать с параметризацией, но уже поздно
    endgenerate

    localparam STEP_COUNT = EXT_WIDTH / PART_DATA_WIDTH;
    localparam STEP_WIDTH = $clog2(STEP_COUNT);
    reg [STEP_WIDTH- 1 : 0] step;

    wire [PART_DATA_WIDTH - 1 : 0] part_second [STEP_COUNT - 1 : 0];
    genvar i;
    generate for(i = 0; i < STEP_COUNT; i = i + 1) begin : loop_parts
        assign part_second[i] = wr_data_2_save_extended[PART_DATA_WIDTH * (i + 1) - 1 : PART_DATA_WIDTH * i];
    end
    endgenerate

    localparam PART_RES_WIDTH = RES_WIDTH;
    wire [PART_RES_WIDTH - 1 : 0] part_res;

    mul_simple #(.DATA_1_WIDTH(DATA_WIDTH), .DATA_2_WIDTH(PART_DATA_WIDTH), .RES_WIDTH(PART_RES_WIDTH)) mul_simple_main
               (wr_data_1_save, part_second[step], part_res);

    localparam STEP_MUL_PDW_WIDTH = $clog2(STEP_COUNT * PART_DATA_WIDTH); //равнозначно - $clog2(EXT_WIDTH)
    wire [STEP_MUL_PDW_WIDTH - 1 : 0] step_mul_PDW;

    //я запрещаю умножать
    localparam PDW_WIDTH = $clog2(PART_DATA_WIDTH + 1);
    // для того чтобы цепь была более параллельной, а не последовательной
    // STEP_WIDTH и PDW_WIDTH предполагаются достаточно малыми по сравнению с PART_DATA_WIDTH
    generate if(STEP_WIDTH < PDW_WIDTH) begin : gen_if_compare
    mul_simple #(.DATA_1_WIDTH(STEP_WIDTH), .DATA_2_WIDTH(PDW_WIDTH), .RES_WIDTH(STEP_MUL_PDW_WIDTH))
        mul_simple_step (step, PART_DATA_WIDTH [$clog2(PART_DATA_WIDTH + 1) - 1 : 0], step_mul_PDW);
    end
    else begin
    mul_simple #(.DATA_1_WIDTH(PDW_WIDTH), .DATA_2_WIDTH(STEP_WIDTH), .RES_WIDTH(STEP_MUL_PDW_WIDTH))
        mul_simple_step (PART_DATA_WIDTH [PDW_WIDTH - 1 : 0], step, step_mul_PDW);
    end
    endgenerate


    assign rd_data = result;

    always @(posedge clk)
        if(reset)
            wr_ready <= 1;
        else
            wr_ready <= (wr_en) ? 0 :
                (rd_en & rd_ready) ? 1 : wr_ready;

    always @(posedge clk)
        if(reset)
            rd_ready <= 0;
        else
            rd_ready <= (rd_en) ? 0 :
                (step == STEP_COUNT - 1) ? 1 : rd_ready;

    always @(posedge clk) begin
        if(reset) begin
            wr_data_1_save <= 0;
            wr_data_2_save <= 0;
        end
        else begin
            wr_data_1_save <= (wr_en & wr_ready) ? wr_data_1 : wr_data_1_save;
            wr_data_2_save <= (wr_en & wr_ready) ? wr_data_2 : wr_data_2_save;
        end
    end

    always @(posedge clk)
        if(reset)
            step <= 0;
        else
            step <= (step == STEP_COUNT - 1) ? 0 :
                (~wr_ready) ? step + 1 : step;

    always @(posedge clk)
        if(reset)
            result <= 0;
        else
            result <= (~rd_ready & ~wr_ready) ? result + ((part_res) << step_mul_PDW) : result;

    always @(posedge clk)
        if(reset)
            rd_val <= 0;
        else
            rd_val <= (rd_en) ? rd_ready : rd_val;

endmodule