//NCO test 

class base_test extends uvm_test;
  `uvm_component_utils(nco_test)    //Factory Registration
  nco_environment nco_env;
  i//nco_base_sequence base;

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

class nco_base_test extends uvm_test;
  `uvm_component_utils(nco_base_test)    //Factory Registration
  nco_base_sequence seq;

  function new(string name = "nco_base_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    nco_env = nco_environment::type_id::create("nco_env",this);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration
	
	 virtual task run_phase(uvm_phase);
    seq = nco_base_sequence::type_id::create("nco_base_sequence");
    seq.start(nco_env.active_agent.driver);
  endtask
endclass:nco_test

class nco_normal_test extends base_test;
  `uvm_component_utils(nco_normal_test)    //Factory Registration
  nco_normal_sequence seq;

  function new(string name = "nco_normal_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    nco_env = nco_environment::type_id::create("nco_env",this);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration
	
	 virtual task run_phase(uvm_phase);
    seq = nco_normal_sequence::type_id::create("nco_normal_sequence");
    seq.start(nco_env.active_agent.driver);
	endtask
endclass

class nco_cont_test extends base_test;
  `uvm_component_utils(nco_cont_test)    //Factory Registration
  nco_cont_sequence seq;

  function new(string name = "nco_cont_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    nco_env = nco_environment::type_id::create("nco_env",this);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration
	
	 virtual task run_phase(uvm_phase);
    seq = nco_normal_sequence::type_id::create("nco_cont_sequence");
    seq.start(nco_env.active_agent.driver);
	endtask
endclass

class nco_reset_normal_test extends base_test;
  `uvm_component_utils(nco_reset_normal_test)    //Factory Registration
  nco_reset_normal_sequence seq;

  function new(string name = "nco_reset_normal_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    nco_env = nco_environment::type_id::create("nco_env",this);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration
	
	 virtual task run_phase(uvm_phase);
    seq = nco_reset_normal_sequence::type_id::create("nco_reset_normal_sequence");
    seq.start(nco_env.active_agent.driver);
	endtask
endclass


class nco_no_ip_test extends base_test;
  `uvm_component_utils(nco_no_ip_test)    //Factory Registration
  nco_no_ip_normal_sequence seq;

  function new(string name = "nco_no_ip_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    nco_env = nco_environment::type_id::create("nco_env",this);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration
	
	 virtual task run_phase(uvm_phase);
    seq = nco_no_ip_sequence::type_id::create("nco_no_ip_sequence");
    seq.start(nco_env.active_agent.driver);
	endtask
endclass

class nco_change_req_test extends base_test;
  `uvm_component_utils(nco_change_req_test)    //Factory Registration
  nco_change_req_sequence seq;

  function new(string name = "nco_change_req_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    nco_env = nco_environment::type_id::create("nco_env",this);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration
	
	 virtual task run_phase(uvm_phase);
    seq = nco_change_req_sequence::type_id::create("nco_change_req_sequence");
    seq.start(nco_env.active_agent.driver);
	endtask
endclass

class nco_reset_diff_test extends base_test;
  `uvm_component_utils(nco_reset_diff_test)    //Factory Registration
  nco_reset_diff_sequence seq;

  function new(string name = "nco_reset_diff_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    nco_env = nco_environment::type_id::create("nco_env",this);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration
	
	 virtual task run_phase(uvm_phase);
    seq = nco_reset_diff_change::type_id::create("nco_reset_change_sequence");
    seq.start(nco_env.active_agent.driver);
	endtask
endclass


