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
    reg [DATA_WIDTH - 1 : 0] flag_val;

    genvar i;
    generate for(i = 0; i < FIFO_DEPTH; i = i + 1) begin : loopArray
        if(i == 0) begin
            always @(posedge clk) begin

            end
        end
        else if(i == FIFO_DEPTH - 1) begin
            always @(posedge clk) begin

            end
        end
        else begin
            always @(posedge clk) begin

            end
        end
    end
    endgenerate


    endmodule