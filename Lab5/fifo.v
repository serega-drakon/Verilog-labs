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
    reg flag_val [FIFO_DEPTH - 1 : 0];

    assign wr_ready = rd_en | ~flag_val[FIFO_DEPTH - 1];

    always @(posedge clk) begin
        if(wr_en) begin
            array[0] <= wr_data;
            flag_val[0] <= 1;
        end
        else if(reset) begin
            array[0] <= 0;
            flag_val[0] <= 0;
        end
        else begin
            if(rd_en) begin
                flag_val[0] <= 0;
            end
        end
    end

    genvar i;
    generate for(i = 1; i < FIFO_DEPTH; i = i + 1) begin : loopArray
        always @(posedge clk) begin
            if(reset) begin
                array[i] <= 0;
                flag_val[i] <= 0;
            end
            else if(wr_en || rd_en) begin
                array[i] <= array[i - 1];
                flag_val[i] <= flag_val[i - 1];
            end
        end
    end
    endgenerate

    always @(posedge clk) begin
        if(reset) begin
            rd_data <= 0;
            rd_val <= 0;
        end
        else if(rd_en) begin
            rd_data <= array[FIFO_DEPTH - 1];
            rd_val <= flag_val[FIFO_DEPTH - 1];
        end
    end
    endmodule