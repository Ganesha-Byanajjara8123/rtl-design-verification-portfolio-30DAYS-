


//tb code for FIFO-day-6
// i just make it more 


module fifo_syn_tb();
  localparam WIDTH = 8;
  localparam DEPTH = 4;
  
  logic clk;
  logic rst;
  logic wr_en;
  logic rd_en;
  logic [WIDTH-1:0] wdata;
  logic [WIDTH-1:0] rdata;
  logic full;
  logic empty;

  fifo_syn #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) uut (
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .wdata(wdata),
    .rdata(rdata),
    .full(full),
    .empty(empty)
);

  initial begin
    clk = 0;
    forever #15 clk = ~ clk;
  end

  initial begin
    wr_en = 0;
    rd_en = 0;
    wdata = 0;
    rst = 1;
    @(posedge clk);
    @(posedge clk);
    rst = 0;
 // write data/input  
    wdata = 10;
    wr_en = 1;
    @(posedge clk);
    wr_en = 0;
    
    wdata = 20;
    wr_en = 1;
    @(posedge clk);
    wr_en = 0;

    wdata = 30;
    wr_en = 1;
    @(posedge clk);
    wr_en = 0;
    // simultaneous read + write when full
    wdata = 99;
    wr_en = 1;
    rd_en = 1;
    @(posedge clk);
    wr_en = 0;
    rd_en = 0;
    
    wdata = 40;
    wr_en = 1;
    @(posedge clk);
    wr_en = 0;
    
//read data/ output
    rd_en = 1;
    @(posedge clk);
    rd_en = 0;

       rd_en = 1;
    @(posedge clk);
    rd_en = 0;

       rd_en = 1;
    @(posedge clk);
    rd_en = 0;
    
    rd_en = 1;
    @(posedge clk);
    rd_en = 0;
    
    #100; $finish;
  end
  
  initial begin
  $monitor("t=%0t wr_ptr=%0d rd_ptr=%0d full=%0b empty=%0b rdata=%0d",
         $time, uut.wr_ptr, uut.rd_ptr, full, empty, rdata);
  end
endmodule




