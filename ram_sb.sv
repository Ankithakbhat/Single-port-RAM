class ram_sb;
//PROPERTIES
 //Ram transaction class handles
 ram_trx ref2sb_trans,mon2sb_trans;
 //Mailbox for from reference model to scoreboard connection
  mailbox #(ram_trx) mailbox_ref_sb;
 //Mailbox for from monitor to scoreboard connection
  mailbox #(ram_trx) mailbox_mont_sb;
 //2-D arrays used for storing data_out (from reference model, EXPECTED 
 //RESULT) w.r.t address in reference model memory and storing data_out (from 
 //DUV,ACTUAL RESULT) w.r.t address in monitor memory
 logic [`DATA_WIDTH-1:0] ref_mem [`DATA_DEPTH-1:0]; 
 logic [`DATA_WIDTH-1:0] mon_mem [`DATA_DEPTH-1:0]; 
 //Variables to indicate number of matches and mismatches
 int MATCH = 0;
 int MISMATCH = 0;
//METHODS
 //Explicitly overriding the constructor to make mailbox connection from monitor
 //to scoreboard, to make mailbox connection from reference model to scoreboard
  function new(mailbox #(ram_trx) mailbox_ref_sb,
               mailbox #(ram_trx) mailbox_mont_sb);
 this.mailbox_ref_sb = mailbox_ref_sb;
 this.mailbox_mont_sb = mailbox_mont_sb;
 endfunction

//Task which collects data_out from reference model and monitor 
 //and stores them in their respective memories 
 task start();
 for(int i=0;i<`num_transactions;i++)
 begin
 ref2sb_trans=new();
 mon2sb_trans=new();
 fork 
 begin
 //getting the reference model transaction from mailbox 
 mailbox_ref_sb.get(ref2sb_trans);
 ref_mem[ref2sb_trans.address]=ref2sb_trans.data_out;
$display("############SCOREBOARD REF data_out=%0h, ADDRESS=%0h", ref_mem[ref2sb_trans.address], ref2sb_trans.address, $time);
 end
 begin
 //getting the monitor transaction from mailbox 
 mailbox_mont_sb.get(mon2sb_trans);
 mon_mem[mon2sb_trans.address]=mon2sb_trans.data_out;
 $display("!!!!!!!!!!!!!SCOREBOARD MON data_out=%0h, ADDRESS=%0h !!!!!!!!!!!!!!", 
mon_mem[mon2sb_trans.address], mon2sb_trans.address, $time);
 end
 join
 if (i != (`num_transactions-1))
 compare_report();
 end
 endtask


//Task which compares the memories and generates the report 
task compare_report();
 if(ref_mem[ref2sb_trans.address] === mon_mem[mon2sb_trans.address])
 begin
 $display("SCOREBOARD REF data_out=%0h, MON data_out=%0h", 
ref_mem[ref2sb_trans.address], mon_mem[mon2sb_trans.address], $time);
 ++MATCH;
 $display("DATA MATCH SUCCESSFUL. MATCH count = %0d",MATCH);
 end
 else
 begin
 $display("SCOREBOARD REF data_out=%0h, MON data_out=%0h", 
ref_mem[ref2sb_trans.address], mon_mem[mon2sb_trans.address], $time);
 ++MISMATCH;
 $display("DATA MATCH FAILURE. MISMATCH count = %0d",MISMATCH);
 end
endtask
endclass
