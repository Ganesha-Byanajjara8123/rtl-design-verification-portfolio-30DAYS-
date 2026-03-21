// Code your design here
// Code your design here

//deign code of alu
interface alu_if;
  logic clk;
  logic [7:0] A;
  logic [7:0] B;
  logic [2:0] op;
  logic [7:0] result;
  
  //for assertion (DAY25)
  property add_check;
    @(posedge clk);
    (op == 3'b000) |-> (result == A+B);
           
  endproperty 
  assert property(add_check);
    
endinterface



class alu_txn;
  rand bit [7:0] A;
  rand bit [7:0] B;
  rand bit [2:0] op;
  bit[7:0] result;
  
  constraint op_c{
    op inside {3'b000, 3'b001, 3'b010, 3'b011, 3'b100};
  }
  
  function void display();
    $display("A=0%d, B=0%d, op=0%d", A, B , op);
  endfunction
  
endclass

//for generator with txn
class generator;
  
  //create driver obj and 
//the transaction generated will be sent to driver
  alu_txn txn;
  mailbox mbx;
  
   function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    repeat(100)begin
    txn = new();      
      if(!txn.randomize())
        $error("Randomization Failed");
      mbx.put(txn);
    end
  endtask
      
endclass
    
// for environment
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
        
        mbx_gd = new(mbx_gd);
        mbx_drv = new(mbx_gd, vif);
        mbx_mon = new(mbx_ms, vif);
        mbx_sb  = new(mbx_ms);
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
      

//for active the driver when txn ready
  class driver;
   alu_txn txn;
    mailbox mbx;
    virtual alu_if vif;
     	

    function new(mailbox mbx, virtual alu_if vif);
      this.mbx = mbx;
      this.vif = vif;
      endfunction

    task run();
      wait(!vif.rst);
      forever begin
        mbx.get(txn);  //take transaction from mailbox-store in txn
        @(negedge vif.clk);
        
        txn.display();
        vif.A = txn.A;
        vif.B = txn.B;
        vif.op = txn.op;
      end
      endtask
  endclass
    
//for monitor to observe the DUT

class monitor;     //make flow like Generator → Driver → DUT → Monitor → coverage → Mailbox
  alu_txn txn;
  mailbox mbx;
  virtual alu_if vif;
  
  //for coverage to count and accumulate the op 
   covergroup alu_cg;
     

    cp_op : coverpoint vif.op;
     cp_A : coverpoint vif.A;
     cp_B : coverpoint vif.B;
     
     cross cp_op, cp_A, cp_B;
     
  endgroup
  
  alu_cg cg;// instance for coverage
  
  function  new(mailbox mbx, virtual alu_if vif);
    this.mbx = mbx;
    this.vif = vif;
    cg = new();
   endfunction
 
   task run();
     forever  begin
       @(posedge vif.clk);
     txn = new();
     
     txn.A = vif.A;
     txn.B = vif.B;
     txn.op = vif.op;
     txn.result = vif.result;
     cg.sample();
     mbx.put(txn);
     
    $display("monitor observing transaction");
    txn.display();
     end
  endtask
endclass

//for scoreboard to compare the expected results with DUT
class scoreboard;
  mailbox mbx;
  alu_txn txn;
  
        
  int txn_count = 0;
  int total_txn = 100;
  
  function new(mailbox mbx);
    this.mbx = mbx;
  endfunction
  
  task run();
    forever begin
      mbx.get(txn);
      check(txn);
      
      if(txn_count == total_txn) begin
        $display("All %0d transactions verified. Ending simulation.", total_txn);
        $finish;
      end
    end 
  endtask
  
  task check(alu_txn txn);
    $display("scoreboard checking result = %0d",txn.result);
  endtask
endclass
