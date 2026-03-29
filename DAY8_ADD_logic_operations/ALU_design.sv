

// code for ALU
//hey..! today(DAY8) i build ALU which is perform few operations

module alu #(parameter WIDTH = 8) (
  input logic clk,
  input logic rst,
  input logic [WIDTH-1:0] A,
  input logic [WIDTH-1:0] B,
  input logic [2:0]op, 
  output logic[WIDTH-1:0]result,
  output logic carry,
  output logic zero,
  output logic overflow

);
 
  logic [WIDTH:0] temp;
  
  always_comb begin
    
    carry = 0;
    zero  = 0;
    overflow = 0;
    
    case(op)
      3'b000: begin
        temp = A + B;
    end
      3'b001: begin
        temp = A - B;
      end
      3'b010: begin
        temp = A & B;
      end
      3'b011: begin
        temp = A | B;
      end
      3'b100: begin
        temp = A ^ B;
      end
      default: begin
        temp = 0;
      end
  endcase
      result = temp[WIDTH-1:0];
      carry  = temp[WIDTH];
      zero   = (result == 0);
  end
    endmodule
