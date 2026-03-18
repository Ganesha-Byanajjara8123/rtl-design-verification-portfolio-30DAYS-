
module tb_updown_counter();
    reg clk;
    reg reset;
    reg en;
    reg up_down;
    wire [7:0] count;

    updown_counter_8bit uut (
        .clk(clk),
        .reset(reset),
        .en(en),
        .up_down(up_down),
        .count(count)
    );

    initial begin
        reset = 1'b1; 
        reset = 1'b1;
        en = 1'b0;
        up_down = 1'b0;

        #10;
        reset = 1'b0; 
        
        en = 1'b1;
        up_down = 1'b1;
        #200; 
        up_down = 1'b0;
       #50;
        reset = 1'b1;
        #10;
        en = 1'b0;
        reset = 1'b0; 
        #50;

        $display("Simulation finished");
        $finish; 
    end

    initial begin
      $monitor("Time=%0t, Reset=%0b, en=%0b, Up/Down=%0b, Count=%0d", $time, reset, en, up_down, count);  
    end
endmodule
