// Code your testbench here
// or browse Examples

 `include "define.sv"
`include "ram_package.sv"

module top();
  // Importing the ram package
  

  // Declaring variables for clock and reset
  logic clk;
  logic reset;

  // Generating the clock
  initial begin
    clk = 0;
    forever #20 clk = ~clk; // Period is 20ns --> Frequency is 25MHz
  end

  // Asserting and de-asserting the reset
  initial begin
    @(posedge clk);
    reset = 1;
    repeat (1) @(posedge clk);
    reset = 0;
  end

  // Instantiating the interface
  ram_if intrf(clk, reset);

  // Instantiating the DUV
  RAM DUV (
    .data_in(intrf.data_in),
    .write_enb(intrf.write_enb),
    .read_enb(intrf.read_enb),
    .data_out(intrf.data_out),
    .address(intrf.address),
    .clk(clk),
    .reset(reset)
  );

  // Instantiating the Test
  ram_test test;

  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    test = new(intrf, intrf, intrf);

    // Calling the test's run task which starts the execution of the testbench architecture
    test.run();
    $finish;
  end
endmodule
