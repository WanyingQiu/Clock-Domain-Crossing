module double_ff
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

// always_ff @(posedge wr_clk or negedge wr_reset) begin 
//     if(!wr_reset) begin 
//         wr_data_q0 <= 0;
//     end 
//     else begin 
//         wr_data_q0 <= wr_data;
//     end 
// end 

always_ff @(posedge rd_clk or negedge rd_reset) begin 
    if(!rd_reset) begin 
        wr_data_q1 <= 0;
        rd_data <= 0;
    end 
    else begin 
        wr_data_q1 <= wr_data;
        rd_data <= wr_data_q1;
    end 
end 

endmodule