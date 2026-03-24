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
