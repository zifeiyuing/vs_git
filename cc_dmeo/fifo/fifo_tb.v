`timescale 1ns/1ps
module fifo_tb ();

parameter    data_width = 7,
             data_depth = 16,
             addr_width = 4,
             PERIOD   = 20;
reg                     clk,rst_n,wr_en,rd_en;
reg [data_width-1:0]    wr_data;
wire                    full,empty;
wire [data_width-1:0]   rd_data;

fifo #(.data_width(data_width),
            .data_depth(data_depth),
            .addr_width(addr_width)
       )
fifo_inst(
    .clk (clk ),
    .rst_n (rst_n ),
    .wr_en (wr_en ),
    .wr_data(wr_data),
    .rd_en (rd_en ),
    .rd_data(rd_data),
    .full(full  ),
    .empty(empty)
);

initial begin
    rst_n = 0;
    clk = 1;
    #5
    rst_n = 1;
end

always #(PERIOD/2)    clk=~clk;

initial begin
    wr_en = 1;
    #20    wr_data = 8'd0;
    #20    wr_data = 8'd1;
    #20    wr_data = 8'd2;
    #20    wr_data = 8'd3;
    #20    wr_data = 8'd4;
    #20    wr_data = 8'd5;
    #20    wr_data = 8'd6;
    #20    wr_data = 8'd7;
    #20    wr_data = 8'd8;
    #20    wr_data = 8'd9;
 
	#20
    rd_en = 1;
    wr_en = 0;
	#20
    rd_en = 1;
    wr_en = 0;
	#20
    rd_en = 1;
    wr_en = 0;
	#20  
    rd_en = 0;
    wr_en = 1;
    wr_data = 8'd88;
	#20    wr_data = 8'd11;
	#20    wr_data = 8'd12;
	#20 
	rd_en = 1;
    wr_en = 0;
	#20
    rd_en = 1;
    wr_en = 1;
	wr_data = 8'd33;
	#20
	wr_en = 1;
	rd_en = 1;
	wr_data = 8'd33;
end
endmodule
