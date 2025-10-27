//NCO sequence item 
`include "define.svh"
class nco_sequence_item extends uvm_sequence_item;
  // Inputs to DUT
  logic resetn;
  randc logic [`SELECT_WIDTH-1:0] signal_out;
  
  // Outputs from DUT
  logic [`WAVE_WIDTH-1:0] wave_out;

  //Special Case
  bit in_btw;

  // Factory registration
  `uvm_object_utils_begin(nco_sequence_item)
  `uvm_field_int(resetn,UVM_ALL_ON && UVM_BIN)
  `uvm_field_int(signal_out,UVM_ALL_ON && UVM_DEC)
  `uvm_field_int(wave_out, UVM_ALL_ON && UVM_BIN)
  `uvm_object_utils_end

  function new(string name = "nco_sequence_item");
    super.new(name);
 	endfunction:new
  
endclass:nco_sequence_item
