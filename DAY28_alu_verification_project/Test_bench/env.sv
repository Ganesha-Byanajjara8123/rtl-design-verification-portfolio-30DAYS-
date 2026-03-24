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
