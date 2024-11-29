` timescale 1ns/1ps
module tb_asyn_fifo #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 4
)
();

asyn_fifo asf_FIFO (.*);
localparam mem_depth = 1 << ADDR_WIDTH;
logic [DATA_WIDTH - 1 : 0] mem [ 0 : mem_depth - 1] ={32'd1,32'd2,32'd3,32'd4,32'd5,32'd6,32'd7,32'd8,32'd9,32'd10,32'd11,32'd12,32'd13,32'd14,32'd15, 32'd16};
logic [ADDR_WIDTH-1:0] wr_curr_addr;
logic [ADDR_WIDTH-1:0] rd_curr_addr;
logic rd_ready;
//signals
logic wreset_n;
logic wr_clk;
logic [DATA_WIDTH - 1 : 0] wr_data;
logic wr_en;

// Reader side 
logic rd_clk;
logic rd_en;
logic rreset_n;
//ouput signals
logic [DATA_WIDTH - 1 : 0] rd_data;
logic rd_empty;
logic wr_full;

task write2fifo (); 
    @(negedge wr_clk);
    if(!wr_full) begin
        $display("[%0t]Writting %d to memory...", $time, mem[wr_curr_addr]);
        wr_data = mem[wr_curr_addr];
        wr_en = 1'b1;
    end  
    @(posedge wr_clk);
    @(posedge wr_clk);
    wr_en = 1'b0;
    wr_curr_addr += 1'b1;
endtask

task readfromfifo ();
    if(rd_curr_addr==0)begin
        @(negedge rd_clk);

        rd_ready = 1'b1;
        @(negedge rd_clk);
        rd_ready = 1'b0;
    end 
    else begin 
        @(negedge rd_clk); 
        if(!rd_empty)begin 
            rd_en = 1'b1;
        
            @(posedge rd_clk);
            @(negedge rd_clk);
            rd_en = 1'b0;
            // $display("[%0t]pulling ready signal to high", $time);
            rd_ready = 1'b1;
            @(negedge rd_clk);
            rd_ready = 1'b0;
        end
    end 
endtask

//check if data read matches testcases memory
// always @(posedge rd_clk)begin 
always @(posedge rd_ready) begin
    assert(rd_data == mem[rd_curr_addr]) begin 
        $display("[%0t]Data read: %d, Expected data: %d", $time, rd_data, mem[rd_curr_addr]);
    end else 
        $error("[%0t]Error: data %d, read does not match testcases %d;", $time, rd_data,  mem[rd_curr_addr] );
    rd_curr_addr =rd_curr_addr+ 1'b1;
end 

initial begin
    wr_clk = 1'b1;
    forever begin
        #10 wr_clk = ~wr_clk;
    end 
end 
initial begin 
    rd_clk = 1'b1;
    forever begin
        #20 rd_clk = ~rd_clk;
    end 
end 

initial begin 
    wreset_n = 1'b0;
    rreset_n = 1'b0;
    rd_ready = 1'b0;
    wr_en = 1'b0; rd_en = 1'b0;
    wr_data = 0;
    @(posedge wr_clk); wreset_n = 1'b1;
    @(posedge rd_clk); rreset_n = 1'b1;
    wr_curr_addr = 0; rd_curr_addr = 0;
    $display("Test1: 1W/1 fast clock cycle & 1R/1 slow clock cycle");
    foreach (mem[i]) begin 
        write2fifo();
        readfromfifo();
    end 
    #100;
    $stop;
end 
endmodule 