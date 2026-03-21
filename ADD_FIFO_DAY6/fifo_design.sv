
// Code your design here

//day6 i build FIFO 

module fifo_syn #(parameter WIDTH = 8, 
                  parameter DEPTH = 4)
  
  (
  input logic  clk,
  input logic rst,
  input logic wr_en,
  input logic rd_en,
  input logic [WIDTH-1:0] wdata,
  output logic [WIDTH-1:0] rdata,
  output logic full,
   output logic empty

);
  logic [WIDTH-1:0] mem [0:DEPTH-1];
 logic [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr;
  logic [$clog2(DEPTH)-1:0] next_wr_ptr;
  assign next_wr_ptr = wr_ptr + 1;
  assign full = (next_wr_ptr == rd_ptr);

  always_ff@(posedge clk) begin
    if(rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      rdata  <= 0;
    end
 else begin
   if (wr_en && (!full || rd_en)) begin
      mem [wr_ptr] <= wdata;
      wr_ptr       <= wr_ptr + 1;
    end
   if(rd_en && !empty) begin
     rdata <= mem [rd_ptr] ;
      rd_ptr       <= rd_ptr + 1;
    end  
  end
  end
  
  assign empty = (wr_ptr == rd_ptr);

endmodule
  

  
