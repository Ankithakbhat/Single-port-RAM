class ram_moni;
//PROPERTIES
 //Ram transaction class handle
 ram_trx mon_trans;
 //Mailbox for monitor to scoreboard connection
  mailbox #(ram_trx) mailbox_mont_sb;
 //Virtual interface with monitor modport and its instance 
 virtual ram_if.MON vif;
//FUNCTIONAL COVERAGE for outputs
 covergroup mon_cg;
 DATA_OUT: coverpoint mon_trans.data_out {bins dout ={[0:255]};}
 endgroup
//METHODS
 //Explicitly overriding the constructor to make mailbox connection from monitor
 //to scoreboard, and to connect the virtual interface from monitor to environment 
 function new( virtual ram_if.MON vif,
              mailbox #(ram_trx)  mailbox_mont_sb);
 this.vif=vif;
 this.  mailbox_mont_sb=  mailbox_mont_sb;
 //Creating the object for covergroup
 mon_cg=new();
 endfunction
//Task to collect the output from the interface
 task start();
 repeat(4) @(vif.mon_cb); 
 for(int i=0;i<`num_transactions;i++)
 begin
 mon_trans=new();
 repeat(1) @(vif.mon_cb)
 begin
 mon_trans.data_out=vif.mon_cb.data_out;
 end
 $display("MONITOR PASSING THE DATA TO SCOREBOARD data_out=%0h", 
mon_trans.data_out, $time);
 //Putting the collected outputs to mailbox 
 mailbox_mont_sb.put(mon_trans);
 //Sampling the covergroup
 mon_cg.sample();
 $display("OUTPUT FUNCTIONAL COVERAGE = %0d", mon_cg.get_coverage());
 repeat(1) @(vif.mon_cb);
 end
 endtask
endclass
