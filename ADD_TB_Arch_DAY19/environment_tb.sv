module tb;
  
  alu_if vif();
  env e;

  initial begin
    e = new(vif);
      e.run();
  end
endmodule
