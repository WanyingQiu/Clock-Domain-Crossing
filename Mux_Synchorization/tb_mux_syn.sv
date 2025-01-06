` timescale 1ns/1ps
module tb_mux_syn#(parameter DATA_WIDTH = 12
) ();
mux_syn mux_syn(.*);
logic[DATA_WIDTH-1: 0] wr_data;
logic wr_req;
logic wr_clk;
logic wr_reset;

logic rd_clk;
logic rd_reset;

logic [DATA_WIDTH-1: 0] rd_data;

//Slow to fast clock
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
property delay_verif;
    @(posedge rd_clk) disable iff(rd_reset)
    always ##2 rd_data == $past(wr_data,2);
    // always ##2 rd_data == 1;
endproperty

initial begin 
    wr_data = 0;
    wr_req = 0;
    wr_reset = 1'b0;
    rd_reset = 1'b0;
    @(posedge wr_clk);
    @(negedge wr_clk); wr_reset = 1'b1;
    @(negedge rd_clk); rd_reset = 1'b1;

    wr_data = $urandom();	
    
    @(negedge wr_clk);
    wr_req = 1;	
    @(negedge wr_clk);
    @(posedge rd_clk);
    wr_req = 0;	
    @(posedge rd_clk);
    // wr_req = 0;	
    @(posedge rd_clk);
    
    #500;
    $stop;
end
endmodule 