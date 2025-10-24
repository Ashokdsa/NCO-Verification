//NCO Sequencer class

class nco_sequencer extends uvm_sequencer#(nco_sequence_item);
  `uvm_component_utils(nco_sequencer)    // Register with the factory

  function new(string name = "nco_sequencer",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new
endclass:nco_sequencer
