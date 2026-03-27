
##day11 i build 
Transaction
Generator
Driver
Mailbox communication
Parallel execution (fork/join)

module tb;
  
mailbox mbx;
generator gen;
driver drv;
  
  initial begin
    mbx = new();
    
    gen = new(mbx);
    drv = new(mbx);
    
    fork
    gen.run();
    drv.run();
    join
    
  end
endmodule


