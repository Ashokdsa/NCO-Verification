// Top-level module for NCO UVM testbench

`include "nco_interface.sv"
`include "nco_pkg.svh"
import uvm_pkg::*;
import nco_pkg::*;
//DESIGN PATH

module top;
  bit clk;

  // Clock generation : 20ns period 

  // Interface instantiation
  nco_inf vif(clk);     

  // DUT instantiation
  
  initial begin:setting_vif
    // UVM Configurations setting
    uvm_config_db#(virtual nco_inf)::set(null, "*", "vif", vif);
    $dumpfile("wave.vcd");
    $dumpvars(0);
  end:setting_vif

  initial begin:initial_reset
  end:initial_reset

  initial begin:test_run
    run_test("nco_test");      // Start UVM test
    $finish;
  end:test_run

endmodule:top
