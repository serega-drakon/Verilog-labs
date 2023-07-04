module fifo #(
    parameter FIFO_DEPTH = 8,
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire reset,
    input wire rd_en,
    input wire wr_en,
    input wire [DATA_WIDTH - 1 : 0] wr_data,
    output reg [DATA_WIDTH - 1 : 0] rd_data,
    output wire wr_ready,
    output reg rd_val
);
    reg [DATA_WIDTH - 1 : 0] array [FIFO_DEPTH - 1 : 0];
    reg [$clog2(FIFO_DEPTH) : 0] len;

    assign wr_ready = !(len == FIFO_DEPTH);

    //вынес за знаки условий общие действия
    always @(posedge clk) begin
        if(wr_en) begin
            array[0] <= wr_data;
        end
        if(rd_en) begin
            rd_data <= array[0];
            rd_val <= !(len == 0);
        end
    end

    //далее пошли различия по алгоритму действий
    //RESET
    always @(posedge clk) begin
        if(reset) begin
            if(wr_en) begin
                len <= 1;
            end
            else begin
                array[0] <= 0;
                len <= 0;
            end
        end
    end

    genvar i;
    generate for(i = 1; i < FIFO_DEPTH; i = i + 1)
        always @(posedge clk)
            if(reset)
                array[i] <= 0;
    endgenerate

    //READ
    wire onlyRD;
    assign onlyRD = !reset && !wr_en && rd_en;

    always @(posedge clk) begin
        if(onlyRD && len > 0)
                len <= len - 1;
    end

    generate for(i = 0; i < FIFO_DEPTH - 1; i = i + 1)
        always @(posedge clk)
            if(onlyRD)
                array[i] <= array[i + 1];
    endgenerate

    //WRITE
    wire onlyWR;
    assign onlyWR = !reset && !rd_en && wr_en;

    always @(posedge clk) begin
        if(onlyWR && len < FIFO_DEPTH)
                len <= len + 1;
    end

    generate for(i = 0; i < FIFO_DEPTH - 1; i = i + 1)
        always @(posedge clk)
            if(onlyWR)
                array[i + 1] <= array[i];
    endgenerate

    //READ&WRITE
    wire onlyRDWR;
    assign onlyRDWR = !reset && rd_en && wr_en;

    always @(posedge clk)
        if(onlyRDWR && len == 0)
            len <= 1;
endmodule
//наверное я фигово оформил, пока чето красивое пытаюсь выдавать