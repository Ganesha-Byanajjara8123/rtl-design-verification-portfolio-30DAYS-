module alu(
  input  logic clk,
  input  logic [7:0] A,
  input  logic [7:0] B,
  input  logic [2:0] op,
  output logic [7:0] result
);

always_comb begin
  case(op)

    3'b000: result = A + B;
    3'b001: result = A - B;
    3'b010: result = A & B;
    3'b011: result = A | B;

    // BUG INJECTED HERE
    3'b100: result = A | B;   // should be XOR but changed intentionally

    default: result = 0;

  endcase
end

endmodule
