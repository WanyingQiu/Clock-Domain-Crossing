module mux_syn #(
    parameter DATA_WIDTH = 12
)
(
    input logic[DATA_WIDTH-1: 0] wr_data,
    input logic wr_req,
    input logic wr_clk,
    input logic wr_reset,

    input logic rd_clk,
    input logic rd_reset,

    output logic [DATA_WIDTH-1: 0] rd_data
);

logic rd_mux_sel;
logic wr_data_q;
logic wr_data_q0;
logic wr_data_q1;
logic wr_data_q2;

logic [DATA_WIDTH-1: 0] wr_data_reg;
logic [DATA_WIDTH-1: 0] rd_data_reg;


always_ff @(posedge wr_clk or negedge wr_reset) begin 
    if(!wr_reset) begin 
        wr_data_q <= 0;
        wr_data_reg <= 0;
    end 
    else begin 
        wr_data_q <= wr_req;
        wr_data_reg <= wr_data;
    end 
end 

always_ff @(posedge wr_clk or negedge wr_reset) begin 
    if(!wr_reset) begin 
        wr_data_q <= 0;
    end 
    else begin 
        wr_data_q <= wr_req;
    end 
end 

assign rd_mux_sel = (~wr_data_q2 & wr_data_q1) ;
always_ff @(posedge rd_clk or negedge rd_reset) begin 
    if(!rd_reset) begin 
        wr_data_q0 <= 0;
        wr_data_q1 <= 0;
        wr_data_q2 <= 0;

        rd_data <= 0;
    end 
    else begin 
        wr_data_q0 <= wr_data_q;
        wr_data_q1 <= wr_data_q0;
        wr_data_q2 <= wr_data_q1;

        rd_data <= rd_data_reg;
    end 
end 

always_comb begin 
     if(!rd_reset) begin 
        rd_data_reg <= 0;
    end 
    else begin 
       rd_data_reg = (rd_mux_sel == 1) ? wr_data_reg : rd_data;
    end 
end

endmodule