module memory_module #(
    parameter DATA_WIDTH = 8,
    parameter MAX_ADDR = 64,
    parameter ADDRSIZE = log2(MAX_ADDR)
)(
    input wire clk,
    input wire rd_en,
    input wire [ADDRSIZE - 1 : 0] rd_addr,
    input wire wr_en,
    input wire [ADDRSIZE - 1 : 0] wr_addr,
    input wire [DATA_WIDTH - 1 : 0] wr_data,
    output reg [DATA_WIDTH - 1 : 0] rd_data
);

    function integer log2; //тэээк как бы накалякать чтобы оно запустилось...
        input integer value;
        integer tmp;
        begin
            log2 = 0;
            for(tmp = 1; tmp < value; tmp = tmp * 2)
                log2 = log2 + 1;
        end
    endfunction

    reg [DATA_WIDTH - 1 : 0] mem_cell [MAX_ADDR - 1 : 0];

    always @(posedge clk) begin

        if(rd_en) begin
            rd_data <= mem_cell[rd_addr];
        end
    end

    always @(posedge clk) begin
        if(wr_en) begin
            mem_cell[wr_addr] <= wr_data;
        end
    end


endmodule

