module filo #(
    parameter FILO_DEPTH = 8,
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
    reg [DATA_WIDTH - 1 : 0] array [FILO_DEPTH - 1 : 0];
    reg [$clog2(FILO_DEPTH + 1) - 1 : 0] len;

    assign wr_ready = !(len == FILO_DEPTH);

    always @(posedge clk) begin
        if(rd_en)
            rd_data <= array[0];
    end

    generate if(FILO_DEPTH > 1) begin : ifgenStack
        always @(posedge clk) begin
            if(wr_en) begin
                array[0] <= wr_data;
            end
            else if(reset) begin
                array[0] <= 0;
            end
            else if(rd_en) begin
                array[0] <= array[1];
            end
        end
    end
    else if(FILO_DEPTH == 1) begin : ifgenSimpleStack
        always  @(posedge clk) begin
            if(wr_en) begin
                array[0] <= wr_data;
            end
            else if(reset) begin
                array[0] <= 0;
            end
        end
    end
    endgenerate

    genvar i;
    generate for(i = 1; i < FILO_DEPTH; i = i + 1) begin : loopArray
        if(i != FILO_DEPTH - 1) begin
            always @(posedge clk)
                if(reset)
                    array[i] <= 0;
                else if(wr_en && !rd_en)
                    array[i] <= array[i - 1];
                else if(!wr_en && rd_en)
                    array[i] <= array[i + 1];
        end
        else begin
            always @(posedge clk)
                if(reset)
                    array[i] <= 0;
                else if(wr_en && !rd_en)
                    array[i] <= array[i - 1];
        end
    end
    endgenerate

    always @(posedge clk) begin
        if(rd_en)
            rd_val <= !(len == 0);
    end

    always  @(posedge clk) begin
        if(reset) begin
            if(wr_en)
                len <= 1;
            else
                len <= 0;
        end
        else if(!wr_en && rd_en && len > 0)
            len <= len - 1;
        else if(wr_en && !rd_en && len < FILO_DEPTH)
            len <= len + 1;
        else if(wr_en && rd_en && len == 0)
            len <= 1;
    end
endmodule