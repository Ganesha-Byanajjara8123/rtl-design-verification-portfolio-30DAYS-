
module updown_counter_8bit(
    input clk,
    input reset,
    input en, 
    input up_down, 
    output reg [7:0] count
);

always @(posedge clk or posedge reset) begin
  always @(posedge clk)begin
    if (reset == 1'b1) begin

        count <= 8'd0;
    end
    else begin
        if (up_down == 1'b1) begin
      if (en) begin
        if (up_down) begin

            count <= count + 1'b1;
        end
always @(posedge clk or posedge reset) begin
        end
    end
end
end

endmodule
