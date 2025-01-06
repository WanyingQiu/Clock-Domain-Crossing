module toggle_syn
(
    input logic wr_data,
    input logic wr_clk,
    input logic wr_reset,

    input logic rd_clk,
    input logic rd_reset,

    output logic rd_data
);

logic mux_sel;
logic wr_data_q;
logic wr_data_q0;
logic wr_data_q1;
logic wr_data_q2;

always_ff @(posedge wr_clk or negedge wr_reset) begin 
    if(!wr_reset) begin 
        wr_data_q <= 0;
    end 
    else begin 
        wr_data_q <= mux_sel;
    end 
end 
// assign mux_sel = (wr_data_q ^ wr_data);
assign rd_data = (wr_data_q2 ^ wr_data_q1) ;
always_ff @(posedge rd_clk or negedge rd_reset) begin 
    if(!rd_reset) begin 
        wr_data_q0 <= 0;
        wr_data_q1 <= 0;
        wr_data_q2 <= 0;
    end 
    else begin 
        wr_data_q0 <= wr_data_q;
        wr_data_q1 <= wr_data_q0;
        wr_data_q2 <= wr_data_q1;
    end 
end 

always_comb begin 
    if(!wr_reset) 
        mux_sel = 0;
    else begin 
        if(wr_data == 1'b1)
            mux_sel = ~wr_data_q;
        else 
            mux_sel =  wr_data_q;
    end 
end 
endmodule