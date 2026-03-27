

//for transanction
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
  driver  drv;
  
  task run();
    drv = new();
    
    repeat(5)begin
    txn = new(); 
    txn.randomize();
    drv.driver(txn);
    txn.display();
    end
  endtask
      
endclass

//for active the driver when txn ready
class driver;
  monitor mon;
  scoreboard sb;
  
    
  task drive(alu_txn txn);
    	
    $display("driver reccieved transaction");
      txn.display();
    mon.observe(txn);
    sb.check(txn;)
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


    
