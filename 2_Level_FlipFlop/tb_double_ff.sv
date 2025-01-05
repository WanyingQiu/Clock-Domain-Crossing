` timescale 1ns/1ps
module tb_double_ff ();
double_ff double_ff(.*);
logic wr_data;
logic wr_clk;
logic wr_reset;

logic rd_clk;
logic rd_reset;

logic rd_data;

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
property delay_verif;
    @(posedge rd_clk) disable iff(rd_reset)
    always ##2 rd_data == $past(wr_data,2);
    // always ##2 rd_data == 1;
endproperty

initial begin 
    wr_data = 0;
    wr_reset = 1'b0;
    rd_reset = 1'b0;
    @(posedge wr_clk);
    @(negedge wr_clk); wr_reset = 1'b1;
    @(negedge rd_clk); rd_reset = 1'b1;

    $display("Test1: 1W/1 fast clock cycle & 1R/1 slow clock cycle");
    for(int i = 0; i < 20; i++)
	begin
        @(posedge wr_clk);
		wr_data = $random;		
        assert property (delay_verif)  
            $display("Passed test");
        else 
            $error("Errod: signal did not match");

	end
    #100;
    $stop;
end
endmodule 