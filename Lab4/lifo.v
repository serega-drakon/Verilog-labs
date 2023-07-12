module lifo#(
    parameter LIFO_DEPTH = 8,
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
    localparam LEN_LENTH = $clog2(LIFO_DEPTH + 1);

    reg [DATA_WIDTH - 1 : 0] array [LIFO_DEPTH - 1 : 0];
    reg [LEN_LENTH - 1 : 0] len;

    assign wr_ready = len < LIFO_DEPTH;
    assign rd_ready = len > 0;

    assign rd_data = array[0];

    always @(posedge clk) begin
        if(reset)
            rd_val <= 0;
        else
            rd_val <= (rd_en) ? rd_ready : rd_val;
    end

    generate if(LIFO_DEPTH > 1) begin : ifgenStack
        always @(posedge clk) begin
            if(reset)
                array[0] <= array[0];
            else
                array[0] <= (wr_en & wr_ready) ? wr_data :
                    (rd_en) ? array[1] : array[0];
        end
    end
    else if(LIFO_DEPTH == 1) begin : ifgenSimpleStack
        always  @(posedge clk) begin
            if(reset)
                array[0] <= array[0];
            else
                array[0] <= (wr_en & wr_ready) ? wr_data : array[0];
        end
    end
    endgenerate

    genvar i;
    generate for(i = 1; i < LIFO_DEPTH; i = i + 1) begin : loopArray
        if(i != LIFO_DEPTH - 1) begin
            always @(posedge clk)
                if(reset)
                    array[i] <= array[i];
                else
                    array[i] <= (wr_en & wr_ready & ~rd_en) ? array[i - 1] :
                        (~wr_en & rd_en & rd_ready) ? array[i + 1] : array[i];
        end
        else begin
            always @(posedge clk)
                if(reset)
                    array[i] <= array[i];
                else
                    array[i] <= (wr_en & wr_ready & ~rd_en) ? array[i - 1] : array[i];
        end
    end
    endgenerate

    always  @(posedge clk) begin
        if(reset)
            len <= 0;
        else
            len <= (~wr_en & rd_en & len > 0) ? len - 1 :
            (wr_en & ~rd_en & wr_ready) ? len + 1 :
            (wr_en & rd_en & len == 0) ? 1 : len;
    end
endmodule