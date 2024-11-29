module asyn_fifo #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4
)
(
    //Writer side
    input logic wreset_n,
    input logic wr_clk,
    input logic [DATA_WIDTH - 1 : 0] wr_data,
    input logic wr_en,

    // Reader side 
    input logic rd_clk,
    input logic rd_en,
    input logic rreset_n,
    //ouput signals
    output logic [DATA_WIDTH - 1 : 0] rd_data,
    output logic rd_empty,
    output logic wr_full
);

localparam FIFO_DEPTH = 1 << ADDR_WIDTH;
logic [DATA_WIDTH - 1 : 0] mem [FIFO_DEPTH - 1: 0];
logic [ADDR_WIDTH-1:0] wr_bin, wr_ptr1, wr_ptr2; // Sychorization Pointers
logic [ADDR_WIDTH-1:0] rd_bin, rd_ptr1, rd_ptr2;
logic [ADDR_WIDTH-1:0] wr_grey_ptr, wr_bin_ptr;
logic [ADDR_WIDTH-1:0] rd_grey_ptr, rd_bin_ptr;
logic [ADDR_WIDTH-1:0] wr_grey, rd_grey;
logic [ADDR_WIDTH-1:0] rd_addr, wr_addr;

logic wr_full_temp, rd_empty_temp;

assign rd_data = mem[rd_addr];
always @(posedge wr_clk or negedge wreset_n) begin
    if(wr_en && wreset_n)
        mem[wr_addr] <= wr_data;
end

//2-level DFF Synchrozation on both clock domains
always @(posedge wr_clk or negedge wreset_n) begin
    if(!wreset_n) 
        {wr_ptr2, wr_ptr1} <= 0;
    else 
        {wr_ptr2, wr_ptr1} <= {wr_ptr1, rd_grey};
end 

always @(posedge rd_clk or negedge rreset_n) begin
    if(!rreset_n) 
        {rd_ptr2, rd_ptr1} <= 0;
    else 
        {rd_ptr2, rd_ptr1} <= {rd_ptr1, wr_grey};
end 

//Grey Code Encoder & overflow signal 
assign wr_grey_ptr = (wr_bin_ptr >> 1) ^ wr_bin_ptr;
assign wr_full_temp = (wr_grey_ptr == {~wr_ptr2[ADDR_WIDTH:ADDR_WIDTH-1], wr_ptr2[ADDR_WIDTH-2:0]});
assign wr_bin_ptr = wr_bin + (wr_en && ~wr_full);
assign wr_addr = wr_bin[ADDR_WIDTH-1:0];
always @(posedge rd_clk or negedge rreset_n)begin 
    if(!wreset_n) begin 
        {wr_bin, wr_grey} <= 0;
        wr_full <= 1'b0;
    end
    else begin 
        {wr_bin, wr_grey} <= {wr_bin_ptr, wr_grey_ptr};
        wr_full <= wr_full_temp;
    end
end 

//Grey Code Decoder & empty signal 
assign rd_grey_ptr = (rd_bin_ptr << 1) ^ rd_bin_ptr;
assign rd_bin_ptr = rd_bin + (rd_en && ~rd_empty);
assign rd_empty_temp = (rd_grey_ptr == rd_ptr2);
assign rd_addr = rd_bin[ADDR_WIDTH-1:0];
always @(posedge rd_clk or negedge rreset_n)begin 
    if(!rreset_n) begin 
        {rd_bin, rd_grey} <= 0;
        rd_empty <= 1'b1;
    end
    else begin 
        {rd_bin, rd_grey} <= {rd_bin_ptr, rd_grey_ptr} ;
        rd_empty <= rd_empty_temp;
    end
end 


endmodule
