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
    output wire rd_ready,
    output reg rd_val
);
    function integer next_pos; // Си-шный style
        input integer pos;
        begin
            if(pos < FIFO_DEPTH - 1)
                next_pos = pos + 1;
            else
                next_pos = 0;
        end
    endfunction

    reg [DATA_WIDTH - 1 : 0] array [FIFO_DEPTH - 1 : 0];
    reg [$clog2(FIFO_DEPTH + 1) - 1 : 0] wr_pos;
    reg [$clog2(FIFO_DEPTH + 1) - 1 : 0] rd_pos;
    reg filled;

    assign wr_ready = !filled || wr_pos != rd_pos;
    assign rd_ready = filled || rd_pos != wr_pos;

    always @(posedge clk) begin
        if(reset) begin
            rd_data <= 0;
            rd_val <= 0;
        end
        else begin
            if(wr_en)
                array[wr_pos] <= wr_data;
            if(rd_en) begin
                rd_data <= array[rd_pos];
                rd_val <= rd_ready;
            end
        end
    end

    always @(posedge clk) begin
        if(reset) begin
            wr_pos <= 0;
            rd_pos <= 0;
        end
        else begin
            if(wr_en) begin
                wr_pos <= next_pos(wr_pos);
                if(!wr_ready && !rd_en)
                    rd_pos <= next_pos(rd_pos);
            end
            if(rd_en) begin
                if(rd_ready || !wr_en) // случай с зажатым rd и wr при filled = 0 и нулевой длине
                    rd_pos <= next_pos(rd_pos);
                if(!rd_ready && !wr_en)
                    wr_pos <= next_pos(wr_pos);
            end
        end
    end

    always @(posedge clk) begin
        if(reset)
            filled <= 0;
        else if(wr_en && wr_pos == rd_pos)
            filled <= 1;
        else if(rd_en && wr_pos == next_pos(rd_pos))
            filled <= 0;
    end

endmodule