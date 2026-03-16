
// Code your design here
//4:1 MUX

module MUX(
  input  [2:0]  A, B, C, D,
  input  [1:0 ] sel,
  output reg [2:0]  X
);

  always@(*) begin
    case(sel)
      2'b00: X = A;
      2'b01: X = B;
      2'b10: X = C;
      2'b11: X = D;
      default: X = 3'b00; 
    endcase
      end
endmodule
      
      
