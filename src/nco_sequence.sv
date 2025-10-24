//Need to add a queue to not repeat values while writing
//NCO Sequence generates read-write sequences

class nco_base_sequence extends uvm_sequence#(nco_sequence_item); //BASE sequence
  `uvm_object_utils(nco_base_sequence)    //Factory Registration
  nco_sequence_item seq;

  function new(string name = "nco_base_sequence");
    super.new(name);
  endfunction:new

  task body();
  endtask
endclass
