class ram_dv;
//PROPERTIES 
 //Ram transaction class handle
 ram_trx drv_trans;
 //Mailbox for generator to driver connection
  mailbox #(ram_trx) mailbox_gd;
 //Mailbox for driver to reference model connection
  mailbox #(ram_trx) mailbox_dv_ref;
 //Virtual interface with driver modport and its instance 
 virtual ram_if.DRV vif;
//FUNCTIONAL COVERAGE for inputs
covergroup drv_cg;
 WRITE: coverpoint drv_trans.write_enb { bins wrt[ ]={0,1};}
 READ : coverpoint drv_trans.read_enb { bins rd[ ]={0,1};}
 DATA_IN: coverpoint drv_trans.data_in { bins data ={[0:255]};}
 ADDRESS: coverpoint drv_trans.address { bins address={[0:31]};}
 WRXRD: cross WRITE,READ;
endgroup 
//METHODS
 //Explicitly overriding the constructor to make mailbox connection from driver
 //to generator, to make mailbox connection from driver to reference model and
 //to connect the virtual interface from driver to environment 
  function new(mailbox #(ram_trx) mailbox_gd,
               mailbox #(ram_trx) mailbox_dv_ref,
 virtual ram_if.DRV vif);
 this. mailbox_gd = mailbox_gd;
 this. mailbox_dv_ref = mailbox_dv_ref;
 this.vif=vif;
 //Creating the object for covergroup
 drv_cg=new();
 endfunction
 //Task to drive the stimuli 
 task start();
 repeat(3) @(vif.drv_cb);
 for(int i=0;i<`num_transactions;i++)
 begin
 drv_trans=new();
 //Getting the transaction from generator
mailbox_gd.get(drv_trans); 
  if(vif.drv_cb.reset==1)
 repeat(1) @(vif.drv_cb)
 begin
 vif.drv_cb.write_enb<=0;
 vif.drv_cb.read_enb<=0;
 vif.drv_cb.data_in<=8'bz; 
 vif.drv_cb.address<=0;
 mailbox_dv_ref.put(drv_trans);
 repeat(1) @(vif.drv_cb); 
 $display("DRIVER DRIVING DATA TO THE INTERFACE data_in=%0h, write_enb=%0d, read_enb=%0d, address=%0h", 
vif.drv_cb.data_in, vif.drv_cb.write_enb, vif.drv_cb.read_enb, vif.drv_cb.address, $time);
 end
 else
 repeat(1) @(vif.drv_cb)
 begin
 vif.drv_cb.write_enb<=drv_trans.write_enb;
 vif.drv_cb.read_enb<=drv_trans.read_enb;
 vif.drv_cb.data_in<=drv_trans.data_in; 
 vif.drv_cb.address<=drv_trans.address;
 repeat(1) @(vif.drv_cb);
 $display("DRIVER WRITE OPERATION DRIVING DATA TO THE INTERFACE data_in=%0h, write_enb=%0d, read_enb=%0d,address=%0h", vif.drv_cb.data_in, vif.drv_cb.write_enb, vif.drv_cb.read_enb, vif.drv_cb.address, $time); 
 vif.drv_cb.write_enb<=0;
 //Putting the randomized inputs to mailbox 
 mailbox_dv_ref.put(drv_trans);
 //Sampling the covergroup
 drv_cg.sample();
 $display("INPUT FUNCTIONAL COVERAGE = %0d", drv_cg.get_coverage());
 end
 end 
 endtask
endclass 
