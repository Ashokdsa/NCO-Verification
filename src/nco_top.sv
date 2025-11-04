// Top-level module for NCO UVM testbench
`include "nco_interface.sv"
`include "nco_assertion.sv"
`include "nco_pkg.svh"
`include "Design/nco.v"
import uvm_pkg::*;
import nco_pkg::*;
//DESIGN PATH

module top;
  bit clk_50MHz;

  // Clock generation : 20ns period 
  always #10 clk_50MHz = ~clk_50MHz;

  // Interface instantiation
  nco_inf vif(clk_50MHz);

  //Bind Assertion
  bind vif nco_assert assertion(.*);

  // DUT instantiation
  nco DUT(.clk_50MHz(vif.clk),.reset(vif.resetn),.signal_out(vif.signal_out),.wave_out(vif.wave_out));
  
  initial begin:setting_vif
    // UVM Configurations setting
    uvm_config_db#(virtual nco_inf)::set(null, "*", "vif", vif);
    $dumpfile("wave.vcd");
    $dumpvars(0);
  end:setting_vif

  initial begin:initial_reset
    vif.resetn = 0;
    repeat(1)@(posedge clk_50MHz);
    repeat(1)@(posedge clk_50MHz);
    vif.resetn = 1;
  end:initial_reset

  initial begin:test_run
    run_test("nco_normal_test");      // Start UVM test
    $finish;
  end:test_run

endmodule:top
