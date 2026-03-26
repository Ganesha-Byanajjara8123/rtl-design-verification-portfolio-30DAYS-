//for both case1 & case2

module tb;

  alu_if vif();
  env e;

  alu dut (
    .clk(vif.clk),
    .A(vif.A),
    .B(vif.B),
    .op(vif.op),
    .result(vif.result)
  );

  initial begin
    vif.clk = 0;
    forever #5 vif.clk = ~vif.clk;
  end

  initial begin
    vif.rst = 1;
    #20;
    vif.rst = 0;
  end

  initial begin
    e = new(vif);
    e.run();
  end

endmodule
