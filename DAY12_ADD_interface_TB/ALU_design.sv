##In day12 I build the alu with interface concept between driver and DUT that can help monito, driver, scoreboard to access the same signals
  

// Code your design here
interface alu_if;
  logic [7:0] A;
  logic [7:0] B;
  logic [2:0] op;
  logic [7:0] result;
endinterface



class alu_txn;
  rand bit [7:0] A;
  rand bit [7:0] B;
  rand bit [2:0] op;
  
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
    repeat(5)begin
    txn = new();      
    txn.randomize();     
      mbx.put(txn);
    end
  endtask
      
endclass

//for active the driver when txn ready
  class driver;
   alu_txn txn;
    mailbox mbx;
     	

    function new(mailbox mbx, virtual alu_if vif);
      this.mbx = mbx;
      this.vif = vif;
      endfunction

    task run();
      repeat(5) begin
        mbx.get(txn);  //take transaction from mailbox-store in txn
        txn.display();
        vif.A = txn.A;
        vif.B = txn.B;
        vif.op = txn.op;
      end
      endtask
  endclass
    
//for monitor to observe the DUT

class monitor;
  
  task observe(alu_txn txn);
    $display("monitor observing transaction");
    txn.display();
  endtask
endclass

//for scoreboard to compare the expected results with DUT
class scoreboard;
  
  task check(alu_txn txn);
    logic [7:0] expected;
    
    case(txn.op)
      
      3'b000 : expected = txn.A + txn.B;
      3'b001 : expected = txn.A - txn.B;
      3'b010 : expected = txn.A & txn.B;
      3'b011 : expected = txn.A | txn.B;
      3'b100 : expected = txn.A ^ txn.B;
      
      default : expected = 0;
      
        endcase
    
      $display("scoreboard expected = 0%d", expected);
      endtask
endclass
