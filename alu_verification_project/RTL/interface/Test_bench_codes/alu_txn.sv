class alu_txn;

  rand bit [7:0] A;
  rand bit [7:0] B;
  rand bit [2:0] op;
  bit [7:0] result;

  constraint op_c {
    op inside {3'b000,3'b001,3'b010,3'b011,3'b100};
  }

endclass
