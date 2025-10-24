//NCO test 

class nco_test extends uvm_test;
  `uvm_component_utils(nco_test)    //Factory Registration
  nco_environment nco_env;
  nco_base_sequence base;

  function new(string name = "nco_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    nco_env = nco_environment::type_id::create("nco_env",this);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration
endclass:nco_test
