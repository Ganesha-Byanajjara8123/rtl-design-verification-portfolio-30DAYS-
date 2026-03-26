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
