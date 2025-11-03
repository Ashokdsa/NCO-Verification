//NCO test 

class base_test extends uvm_test;  //Test Template
  `uvm_component_utils(base_test)    //Factory Registration
  nco_environment nco_env;
  //nco_base_sequence base;

  function new(string name = "base_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    nco_env = nco_environment::type_id::create("nco_env",this);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

endclass:base_test

class nco_base_test extends uvm_test;  //Base Test
  `uvm_component_utils(nco_base_test)    //Factory Registration
  nco_environment nco_env;
  nco_sequence seq;

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

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
		phase.raise_objection(this, "Raised");
    seq = nco_sequence::type_id::create("nco_sequence");
    seq.start(nco_env.active_agent.sequencer);
		phase.drop_objection(this, "Dropped");
    phase_done.set_drain_time(this,40);    // Drain time before dropping objection
  endtask
endclass:nco_base_test

class nco_normal_test extends base_test; //All waveforms test
  `uvm_component_utils(nco_normal_test)    //Factory Registration
  nco_normal_sequence seq;

  function new(string name = "nco_normal_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
		phase.raise_objection(this);
    seq = nco_normal_sequence::type_id::create("nco_normal_sequence");
    seq.start(nco_env.active_agent.sequencer);
		phase.drop_objection(this);
    phase_done.set_drain_time(this,40);    // Drain time before dropping objection
  endtask
endclass: nco_normal_test

class nco_cont_test extends base_test; //Check Repeatibility of waveforms
  `uvm_component_utils(nco_cont_test)    //Factory Registration
  nco_cont_sequence seq;

  function new(string name = "nco_cont_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
		phase.raise_objection(this);
    seq = nco_cont_sequence::type_id::create("nco_cont_sequence");
    seq.start(nco_env.active_agent.sequencer);
		phase.drop_objection(this);
    phase_done.set_drain_time(this,40);    // Drain time before dropping objection
  endtask
endclass:nco_cont_test

class nco_reset_normal_test extends base_test; //Reset Test
  `uvm_component_utils(nco_reset_normal_test)    //Factory Registration
  nco_reset_normal_sequence#(1,0) seq;

  function new(string name = "nco_reset_normal_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
		phase.raise_objection(this);
    seq = nco_reset_normal_sequence#(1,0)::type_id::create("nco_reset_normal_sequence");
    seq.start(nco_env.active_agent.sequencer);
		phase.drop_objection(this);
    phase_done.set_drain_time(this,40);    // Drain time before dropping objection
  endtask
endclass:nco_reset_normal_test


class nco_no_inp_test extends base_test; //No input is sent -> Checking for quiet state
  `uvm_component_utils(nco_no_inp_test)    //Factory Registration
  nco_no_inp_main_sequence#(1) seq;

  function new(string name = "nco_no_inp_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
		phase.raise_objection(this);
    seq = nco_no_inp_main_sequence#(1)::type_id::create("nco_no_ip_sequence");
    seq.start(nco_env.active_agent.sequencer);
		phase.drop_objection(this);
    phase_done.set_drain_time(this,40);    // Drain time before dropping objection
  endtask
endclass:nco_no_inp_test

class nco_change_req_test extends base_test; //Change in request
  `uvm_component_utils(nco_change_req_test)    //Factory Registration
  nco_change_req_sequence#(56) seq;

  function new(string name = "nco_change_req_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
		phase.raise_objection(this);
    seq = nco_change_req_sequence#(56)::type_id::create("nco_change_req_sequence");
    seq.start(nco_env.active_agent.sequencer);
		phase.drop_objection(this);
    phase_done.set_drain_time(this,40);    // Drain time before dropping objection
  endtask
endclass:nco_change_req_test


class nco_reset_change_test extends base_test; //Trigger reset in between
  `uvm_component_utils(nco_reset_change_test)    //Factory Registration
  nco_reset_change_sequence seq;

  function new(string name = "nco_reset_change_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
		phase.raise_objection(this);
    seq = nco_reset_change_sequence::type_id::create("nco_reset_change_sequeunce");
    seq.start(nco_env.active_agent.sequencer);
		phase.drop_objection(this);
    phase_done.set_drain_time(this,40);    // Drain time before dropping objection
  endtask
endclass:nco_reset_change_test


class nco_reset_diff_test extends base_test; //Trigger of reset between request followed by change in signal_out
  `uvm_component_utils(nco_reset_diff_test)    //Factory Registration
  nco_reset_diff_sequence#(16) seq;

  function new(string name = "nco_reset_diff_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
		phase.raise_objection(this);
    seq = nco_reset_diff_sequence#(16)::type_id::create("nco_reset_change_sequence");
    seq.start(nco_env.active_agent.sequencer);
		phase.drop_objection(this);
    phase_done.set_drain_time(this,40);    // Drain time before dropping objection
  endtask
endclass:nco_reset_diff_test


class nco_regression_test extends base_test; //Regression Test
  `uvm_component_utils(nco_regression_test)    //Factory Registration
  nco_regress_sequence seq;

  function new(string name = "nco_regression_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
		phase.raise_objection(this);
    seq = nco_regress_sequence::type_id::create("nco_regress_sequence");
    seq.start(nco_env.active_agent.sequencer);
		phase.drop_objection(this);
    phase_done.set_drain_time(this,40);    // Drain time before dropping objection
  endtask
endclass:nco_regression_test


class nco_each_test extends base_test; //Regression Test
  `uvm_component_utils(nco_each_test)    //Factory Registration
  nco_each_sequence seq;

  function new(string name = "nco_each_test",uvm_component parent = null);
    super.new(name,parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction:build_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction:end_of_elaboration

  virtual task run_phase(uvm_phase phase);
    uvm_objection phase_done = phase.get_objection();
    super.run_phase(phase);
		phase.raise_objection(this);
    seq = nco_each_sequence::type_id::create("nco_each_sequence");
    seq.start(nco_env.active_agent.sequencer);
		phase.drop_objection(this);
    phase_done.set_drain_time(this,40);    // Drain time before dropping objection
  endtask
endclass:nco_each_test
