class ram_test;
//PROPERTIES
 //Virtual interfaces for driver, monitor and reference model
 virtual ram_if drv_vif;
 virtual ram_if mon_vif;
 virtual ram_if ref_vif;
 //Declaring handle for environment
 ram_env env;
//METHODS
 //Explicitly overriding the constructor to connect the virtual
//interfaces from driver, monitor and reference model to test
 function new(virtual ram_if drv_vif,
 virtual ram_if mon_vif,
 virtual ram_if ref_vif);
 this.drv_vif=drv_vif;
 this.mon_vif=mon_vif;
 this.ref_vif=ref_vif;
 endfunction
 //Task which builds the object for environment handle and 
 //calls the build and start methods of the environment
 task run();
 env=new(drv_vif,mon_vif,ref_vif);
 env.build;
 env.start;
 endtask
endclass
