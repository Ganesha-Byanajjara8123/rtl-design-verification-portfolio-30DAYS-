  
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
