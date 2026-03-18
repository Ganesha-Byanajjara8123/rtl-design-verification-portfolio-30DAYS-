
// Code your design here
// Code your design here
module updown_counter #(parameter WIDTH = 8)(
    input logic clk,
    input logic reset,
    input logic en, 
    input logic up_down,
    output logic [WIDTH-1:0] count,
    output logic tc       //tc (terminal count)
);

  always_ff @(posedge clk)begin
    if (reset == 1'b1) begin
      
        count <= 8'd0;
    end
    else begin
      if (en) begin
        if (up_down) begin
            
            count <= count + 1'b1;
        end
        else begin
           
            count <= count - 1'b1;
        end
    end
end
end
    assign tc = (count == 8'd15);

endmodule
