class scoreboard;

  mailbox mbx;
  alu_txn txn;

  int count = 0;

  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction

  task run();

    forever begin

      mbx.get(txn);

      $display("Scoreboard received result = %0d", txn.result);

      count++;

      if(count == 103) begin
        $display("All transactions checked");
        $finish;
      end

    end

  endtask

endclass
