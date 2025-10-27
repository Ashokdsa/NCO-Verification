//NCO sequence item 

class nco_sequence_item extends uvm_sequence_item;
  // Inputs to DUT
  
  // Outputs from DUT

  // Factory registration
  `uvm_object_utils_begin(nco_sequence_item)
  `uvm_field_int(select_out,UVM_ALL_ON && UVM_DEC)
  `uvm_field_int(wave_out, UVM_ALL_ON && UVM_BIN)
  `uvm_object_utils_end

  function new(string name = "nco_sequence_item");
   		 super.new(name);
 	endfunction:new
  
endclass:nco_sequence_item
