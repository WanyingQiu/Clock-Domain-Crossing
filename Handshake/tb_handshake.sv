` timescale 1ns/1ps
module tb_handshake_syn #(
    parameter DATA_WIDTH = 12
)();
hadnshake_syn hadnshake_syn(.*);
logic[DATA_WIDTH-1: 0] wr_data;
logic wr_req;
logic wr_clk;
logic wr_reset;

logic rd_ack;
logic rd_clk;
logic rd_reset;

logic [DATA_WIDTH-1: 0] rd_data;

//Slow to fast clock
initial begin
    wr_clk = 1'b1;
    forever begin
        #20 wr_clk = ~wr_clk;
    end 
end 
initial begin 
    rd_clk = 1'b1;
    forever begin
        #10 rd_clk = ~rd_clk;
    end 
end 

initial begin 
    wr_data = 0;
    wr_reset = 1'b0;
    rd_reset = 1'b0;
    wr_req = 0;
    rd_ack = 0;
    @(posedge wr_clk);
    @(negedge wr_clk); wr_reset = 1'b1;
    @(negedge rd_clk); rd_reset = 1'b1;

    wr_data = $urandom();
    @(negedge wr_clk);
    wr_req = 1;
    @(posedge wr_clk);
    @(posedge wr_clk);

    @(negedge wr_clk);
    wr_req = 0;
    @(negedge rd_clk);
    assert(wr_data === rd_data)
        rd_ack = 1;
    @(posedge rd_clk);
    @(posedge rd_clk);
    @(negedge rd_clk);
    rd_ack = 0;

    #100;
    $stop;
end
endmodule 