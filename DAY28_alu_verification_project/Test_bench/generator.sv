class generator;

  mailbox mbx;
  alu_txn txn;

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction

  task run();

    repeat(100) begin
      txn = new();
      txn.randomize();
      mbx.put(txn);
    end

    // edge cases
    txn = new(); txn.A = 0;   txn.B = 0;   mbx.put(txn);
    txn = new(); txn.A = 255; txn.B = 255; mbx.put(txn);
    txn = new(); txn.A = 255; txn.B = 1;   mbx.put(txn);

  endtask

endclass
