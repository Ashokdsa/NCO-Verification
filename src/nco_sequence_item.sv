//NCO sequence item 

class nco_sequence_item extends uvm_sequence_item;
  // Inputs to DUT
  
  // Outputs from DUT

  // Factory registration
  `uvm_object_utils_begin(nco_sequence_item)
  `uvm_object_utils_end

  function new(string name = "nco_sequence_item");
   		 super.new(name);
 	endfunction:new
  
endclass:nco_sequence_item
