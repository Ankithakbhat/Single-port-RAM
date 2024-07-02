class ram_gen;
//PROPERTIES
 //Ram transaction class handle 
 ram_trx blueprint;
 //Mailbox for generator to driver connection
  mailbox #(ram_trx) mailbox_gd;
//METHODS
 //Explicitly overriding the constructor to make mailbox
 //connection from generator to driver
  function new(mailbox #(ram_trx) mailbox_gd);
 this. mailbox_gd = mailbox_gd;
 blueprint=new();
 endfunction
//Task to generate the random stimuli
 task start();
 for(int i=0;i<`num_transactions;i++)
 begin
 //Randomizing the inputs
 assert(blueprint.randomize() == 1); // More about assertions in the next chapter
 //Putting the randomized inputs to mailbox 
mailbox_gd.put(blueprint.copy()); 
 $display("GENERATOR Randomized transaction data_in=%0h, write_enb=%0d, read_enb=%0d, address=%0h", blueprint.data_in, blueprint.write_enb, blueprint.read_enb, blueprint.address, $time);
 end
 endtask
endclass
