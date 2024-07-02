class ram_env;
//PROPERTIES
 //Virtual interfaces for driver, monitor and reference model
 virtual ram_if drv_vif;
 virtual ram_if mon_vif;
 virtual ram_if ref_vif;
 //Mailbox for generator to driver connection
  mailbox #(ram_trx) mailbox_gd;
 //Mailbox for driver to reference model connection
  mailbox #(ram_trx) mailbox_dv_ref;
 //Mailbox for reference model to scoreboard connection
  mailbox #(ram_trx) mailbox_ref_sb;
 //Mailbox for monitor to scoreboard connection
  mailbox #(ram_trx) mailbox_mont_sb;
 //Declaring handles for components 
 //generator, driver, monitor, reference model and scoreboard
 ram_gen gen;
 ram_dv drv;
 ram_moni mon;
 ram_ref_model ref_sb;
 ram_sb scb;
//METHODS
 //Explicitly overriding the constructor to connect the virtual interfaces
 //from driver, monitor and reference model to test
 function new (virtual ram_if drv_vif,
 virtual ram_if mon_vif,
 virtual ram_if ref_vif);
 this.drv_vif=drv_vif;
 this.mon_vif=mon_vif;
 this.ref_vif=ref_vif;
 endfunction
 //Task which creates objects for all the mailboxes and components
 task build();
 begin
 //Creating objects for mailboxes
mailbox_gd=new();
mailbox_dv_ref=new();
mailbox_ref_sb=new();
mailbox_mont_sb=new();
 //Creating objects for components and passing the arguments
 //in the function new() i.e the constructor
 gen=new(mailbox_gd);
 drv=new(mailbox_gd,mailbox_dv_ref
,drv_vif);
 mon=new(mon_vif, mailbox_mont_sb);
 ref_sb=new(mailbox_dv_ref
,mailbox_ref_sb,ref_vif);
 scb=new(mailbox_ref_sb,mailbox_mont_sb);
 end
 endtask
//Task which calls the start methods of each component 
 //and also calls the compare and report method
 task start();
 fork
 gen.start();
 drv.start();
 mon.start();
 scb.start();
 ref_sb.start();
 join
 scb.compare_report();
 endtask
endclass
