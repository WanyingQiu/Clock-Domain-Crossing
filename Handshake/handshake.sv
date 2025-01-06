module hadnshake_syn #(
    parameter DATA_WIDTH = 12
)
(
    input logic[DATA_WIDTH-1: 0] wr_data,
    input logic wr_req,
    input logic wr_clk,
    input logic wr_reset,

    input logic rd_ack,
    input logic rd_clk,
    input logic rd_reset,

    output logic [DATA_WIDTH-1: 0] rd_data
);

logic wr_req_q1;
logic wr_req_q2;

logic rd_ack_q1;
logic rd_ack_q2;

assign rd_data = wr_data;
always_ff @(posedge wr_clk or negedge wr_reset) begin 
    if(!rd_reset) begin 
        wr_req_q1 <= 0;
        wr_req_q2 <= 0;
    end 
    else begin 
        wr_req_q1 <= wr_req;
        wr_req_q2 <= wr_req_q1;
    end 
end 

always_ff @(posedge rd_clk or negedge rd_reset) begin 
    if(!rd_reset) begin 
        rd_ack_q1 <= 0;
        rd_ack_q2 <= 0;
    end 
    else begin 
        rd_ack_q1 <= rd_ack;
        rd_ack_q2 <= rd_ack_q1;
    end 
end 

endmodule