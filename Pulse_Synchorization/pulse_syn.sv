module pulse_syn
(
    input logic wr_data,
    input logic wr_clk,
    input logic wr_reset,

    input logic rd_clk,
    input logic rd_reset,

    output logic rd_data
);

logic wr_data_q0;
logic wr_data_q1;
logic wr_data_q2;

assign rd_data = (~wr_data_q2 & wr_data_q1) ;
always_ff @(posedge rd_clk or negedge rd_reset) begin 
    if(!rd_reset) begin 
        wr_data_q0 <= 0;
        wr_data_q1 <= 0;
        wr_data_q2 <= 0;
    end 
    else begin 
        wr_data_q0 <= wr_data;
        wr_data_q1 <= wr_data_q0;
        wr_data_q2 <= wr_data_q1;
    end 
end 

endmodule