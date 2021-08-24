module    fifo #(parameter     data_width = 1000,
                               data_depth = 16,
                               addr_width = 4)
(   input    wire                   clk,
    input    wire                   rst_n,
    input    wire                   wr_en,
    input    wire[data_width-1:0]   wr_data,
    input    wire                   rd_en,
    output   reg [data_width-1:0]   rd_data,
    output   reg                    full,
    output   reg                    empty
);
//addr
reg[addr_width-1:0]        wr_addr,rd_addr;
//memory
reg[data_width-1:0]        mem[data_depth-1:0];
//counter
reg[addr_width-1:0]        count;

wire                    rd_allow = rd_en && !empty;
wire                    wr_allow = wr_en && !full;


//empty
always @(posedge clk or negedge rst_n)
    if (!rst_n)
        empty <= 1'b1;
    else
        empty <= (!wr_en && count[addr_width-1:1]=='b0) && (count[0]==1'b0 || rd_en);

//full
always @(posedge clk or negedge rst_n)
    if (!rst_n)
        full <= 1'b0;
    else
        full <= (!rd_en && count[addr_width-1:1]=={addr_width-1{1'b1}})  && (count[0]==1'b1 || wr_en);

//rd_addr
always @(posedge clk or negedge rst_n)
    if (!rst_n)
        rd_addr <= 'd0;
    else if(rd_allow) begin
        rd_data <= mem[rd_addr];
        rd_addr <= rd_addr + 1'b1;
    end


//wr_addr
always @(posedge clk or negedge rst_n)
    if (!rst_n)
        wr_addr <= 'd0;
    else if(wr_allow) begin
        mem[wr_addr] <= wr_data;
        wr_addr <= wr_addr + 1'b1;
    end

always @(posedge clk or negedge rst_n)
    if (!rst_n)
        count <= 'd0;
    else if ( (!rd_allow && wr_allow) || (rd_allow && !wr_allow) ) begin
        if( wr_allow )
            count <= count + 1'b1;
        else
            count <= count - 1'b1;
    end

endmodule