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
    


class alu_txn;

  rand bit [7:0] A;
  rand bit [7:0] B;
  rand bit [2:0] op;
  bit [7:0] result;

  constraint op_c {
    op inside {3'b000,3'b001,3'b010,3'b011,3'b100};
  }

endclass


    class generator;

  mailbox mbx;
  alu_txn txn;

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction

  task run();

  // random tests
  repeat(100) begin
    txn = new();
    txn.randomize();
    mbx.put(txn);
  end

  // edge cases
  txn = new(); txn.A = 0; txn.B = 0; mbx.put(txn);
  txn = new(); txn.A = 255; txn.B = 255; mbx.put(txn);
  txn = new(); txn.A = 255; txn.B = 1; mbx.put(txn);

  // FORCE BUG DETECTION
  txn = new();
  txn.A = 5;
  txn.B = 3;
  txn.op = 3'b100;   // XOR operation
  mbx.put(txn);

endtask

endclass
    
    class driver;

  mailbox mbx;
  alu_txn txn;
  virtual alu_if vif;

  function new(mailbox mbx, virtual alu_if vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction

  task run();

    wait(!vif.rst);

    forever begin

      mbx.get(txn);

      @(negedge vif.clk);

      vif.A  = txn.A;
      vif.B  = txn.B;
      vif.op = txn.op;

    end

  endtask

endclass
    
    class monitor;

  mailbox mbx;
  alu_txn txn;
  virtual alu_if vif;

  function new(mailbox mbx, virtual alu_if vif);
    this.mbx = mbx;
    this.vif = vif;
  endfunction

  task run();

    forever begin

      @(posedge vif.clk);

      txn = new();

      txn.A = vif.A;
      txn.B = vif.B;
      txn.op = vif.op;
      txn.result = vif.result;

      mbx.put(txn);

    end

  endtask

endclass
    
  class scoreboard;

  mailbox mbx;
  alu_txn txn;

  logic [7:0] expected;
  int count = 0;

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction


  task run();

    forever begin

      mbx.get(txn);

      case(txn.op)

        3'b000: expected = txn.A + txn.B;
        3'b001: expected = txn.A - txn.B;
        3'b010: expected = txn.A & txn.B;
        3'b011: expected = txn.A | txn.B;
        3'b100: expected = txn.A ^ txn.B;   // correct XOR

        default: expected = 0;

      endcase


      if(expected == txn.result)

        $display("PASS : A=%0d B=%0d OP=%0b RESULT=%0d",
                 txn.A, txn.B, txn.op, txn.result);

      else

        $display("FAIL : A=%0d B=%0d OP=%0b EXPECTED=%0d GOT=%0d",
                 txn.A, txn.B, txn.op, expected, txn.result);


      count++;

      if(count == 104) begin
        $display("All transactions checked");
        $finish;
      end

    end

  endtask

endclass
    
    
    class env;

  generator gen;
  driver drv;
  monitor mon;
  scoreboard sb;

  mailbox mbx_gd;
  mailbox mbx_ms;

  virtual alu_if vif;

  function new(virtual alu_if vif);

    this.vif = vif;

    mbx_gd = new();
    mbx_ms = new();

    gen = new(mbx_gd);
    drv = new(mbx_gd, vif);
    mon = new(mbx_ms, vif);
    sb  = new(mbx_ms);

  endfunction


  task run();

    fork
      gen.run();
      drv.run();
      mon.run();
      sb.run();
    join

  endtask

endclass
