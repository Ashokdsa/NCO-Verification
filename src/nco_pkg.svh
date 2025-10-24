`include "uvm_macros.svh"

package nco_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  `include "define.svh"
  `include "nco_sequence_item.sv"
  `include "nco_sequence.sv"
  `include "nco_sequencer.sv"
  `include "nco_driver.sv"
  `include "nco_active_monitor.sv"
  `include "nco_passive_monitor.sv"
  `include "nco_active_agent.sv"
  `include "nco_passive_agent.sv"
  `include "nco_scoreboard.sv"
  `include "nco_subscriber.sv"
  `include "nco_environment.sv"
  `include "nco_test.sv"
endpackage
