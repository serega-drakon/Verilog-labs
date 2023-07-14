module fifo_cycle #(
    parameter FIFO_DEPTH = 8,
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire reset,
    input wire rd_en,
    input wire wr_en,
    input wire [DATA_WIDTH - 1 : 0] wr_data,
    output wire [DATA_WIDTH - 1 : 0] rd_data,
    output wire wr_ready,
    output wire rd_ready,
    output reg rd_val
);
    localparam POS_WIDTH = $clog2(FIFO_DEPTH);

    reg [DATA_WIDTH - 1 : 0] array [FIFO_DEPTH - 1 : 0];
    reg [POS_WIDTH - 1 : 0] wr_pos;
    reg [POS_WIDTH - 1 : 0] rd_pos;
    reg filled;

    wire [POS_WIDTH - 1 : 0] wr_next_pos;
    wire [POS_WIDTH - 1 : 0] rd_next_pos;//больше веревок!!!!!!
    assign wr_next_pos = (wr_pos < FIFO_DEPTH - 1) ? wr_pos + 1 : 0;
    assign rd_next_pos = (rd_pos < FIFO_DEPTH - 1) ? rd_pos + 1 : 0;

    assign wr_ready = ~filled | wr_pos != rd_pos;
    assign rd_ready = filled | rd_pos != wr_pos;

    assign rd_data = array[rd_pos];

    always @(posedge clk) begin
        if(reset)
            array[wr_pos] <= array[wr_pos];
        else
            array[wr_pos] <= (wr_en & wr_ready) ? wr_data : array[wr_pos];
    end

    always @(posedge clk) begin
        if(reset)
            rd_val <= 0;
        else
            rd_val <= (rd_en) ? rd_ready : rd_val;
    end

    always @(posedge clk) begin
        if(reset)
            wr_pos <= 0;
        else
            wr_pos <= (wr_en & wr_ready) ? wr_next_pos : wr_pos;
    end

    always @(posedge clk) begin
        if(reset)
            rd_pos <= 0;
        else
            rd_pos <= (rd_en & rd_ready) ? rd_next_pos : rd_pos;
    end

    always @(posedge clk) begin
        if(reset)
            filled <= 0;
        else
            filled <= (wr_en & wr_pos == rd_pos) ? 1 :
            (rd_en & wr_pos == rd_next_pos) ? 0 : filled;
    end

endmodule