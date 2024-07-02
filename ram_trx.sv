class ram_trx;
//PROPERTIES
 //INPUTS declared as rand variables
 rand logic [`DATA_WIDTH-1:0] data_in;
 rand logic write_enb,read_enb;
  rand logic [4:0] address;
 //OUTPUTS declare as non-rand variables
 logic [`DATA_WIDTH-1:0] data_out;
 //CONSTRAINTS for write_enb and read_enb
 constraint wr_rd_constraint {{write_enb,read_enb} inside{[0:3]};}
 constraint wr_not_equal_rd {{write_enb,read_enb}!=2'b11;}
//METHODS
 //Copying objects 
virtual function ram_trx copy();
 copy = new();
 copy.data_in=this.data_in;
 copy.write_enb=this.write_enb;
 copy.read_enb=this.read_enb;
 copy.address=this.address;
 return copy;
 endfunction
endclass
