interface alu_if;

  logic clk;
  logic rst;
  logic [7:0] A;
  logic [7:0] B;
  logic [2:0] op;
  logic [7:0] result;

  // ADD assertion
  property add_check;
    @(posedge clk)
    (op == 3'b000) |-> (result == A + B);
  endproperty
  assert property(add_check);

  // SUB assertion
  property sub_check;
    @(posedge clk)
    (op == 3'b001) |-> (result == A - B);
  endproperty
  assert property(sub_check);

endinterface
    
