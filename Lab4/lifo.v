module lifo#(
    parameter LIFO_DEPTH = 8,
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
    reg [DATA_WIDTH - 1 : 0] array [LIFO_DEPTH- 1 : 0];
    reg [$clog2(LIFO_DEPTH + 1) - 1 : 0] len;

    assign wr_ready = len < LIFO_DEPTH;
    assign rd_ready = len > 0;

    always @(posedge clk) begin
        if(reset) begin
            rd_data <= 0;
            rd_val <= 0;
        end
        else if(rd_en) begin
            rd_data <= array[0];
            rd_val <= rd_ready;
        end
    end

    generate if(LIFO_DEPTH > 1) begin : ifgenStack
        always @(posedge clk) begin
            if(reset)
                ;
            if(wr_en)
                array[0] <= wr_data;
            else if(rd_en)
                array[0] <= array[1];

        end
    end
    else if(LIFO_DEPTH == 1) begin : ifgenSimpleStack
        always  @(posedge clk) begin
            if(reset)
                ;
            else if(wr_en)
                array[0] <= wr_data;
        end
    end
    endgenerate

    genvar i;
    generate for(i = 1; i < LIFO_DEPTH; i = i + 1) begin : loopArray
        if(i != LIFO_DEPTH- 1) begin
            always @(posedge clk)
                if(reset)
                    ;
                else if(wr_en && !rd_en)
                    array[i] <= array[i - 1];
                else if(!wr_en && rd_en)
                    array[i] <= array[i + 1];
        end
        else begin
            always @(posedge clk)
                if(reset)
                    ;
                else if(wr_en && !rd_en)
                    array[i] <= array[i - 1];
        end
    end
    endgenerate

    always  @(posedge clk) begin
        if(reset)
            len <= 0;
        else if(!wr_en && rd_en && len > 0)
            len <= len - 1;
        else if(wr_en && !rd_en && wr_ready)
            len <= len + 1;
        else if(wr_en && rd_en && len == 0)
            len <= 1;
    end
endmodule