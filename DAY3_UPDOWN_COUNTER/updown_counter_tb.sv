
// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
module updown_counter_tb();
    localparam WIDTH = 4;
    logic clk;
    logic reset;
    logic en;
    logic up_down;
    logic [WIDTH-1:0] count;
    logic tc;
 

    updown_counter uut (
        .clk(clk),
        .reset(reset),
        .en(en),
        .up_down(up_down),
        .count(count),
        .tc(tc)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
       reset = 1'b1; #15;
           
      reset = 1'b0;
        en = 1'b1;
        up_down = 1'b1;
      
     
        @(posedge clk)

        up_down = 1'b1;
      repeat(20) @(posedge clk);
      
        up_down = 1'b0;
      repeat(20) @(posedge clk); 
      

        $display("Simulation finished");
        $finish; 
    end

    initial begin
        $monitor("Time=%0t, Reset=%0b, en=%0b, Up/Down=%0b, Count=%0d, tc=%d", $time, reset, en, up_down, count, tc);  
    end
endmodule
