// NCO Environment: top-level container that instantiates agents, scoreboard, and subscriber

class nco_environment extends uvm_env;
  nco_active_agent    active_agent;
  nco_passive_agent   passive_agent;
  nco_scoreboard 		scoreboard;
  nco_subscriber 		subscriber;
  
  `uvm_component_utils(nco_environment)      // Register this environment with the factory
  
  function new(string name = "nco_environment", uvm_component parent);
    	super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
      uvm_config_db#(uvm_active_passive_enum)::set(this, "active_agent", "is_active", UVM_ACTIVE);
      uvm_config_db#(uvm_active_passive_enum)::set(this, "passive_agent", "is_active", UVM_PASSIVE);
      active_agent = nco_active_agent::type_id::create("active_agent", this);  
    	passive_agent = nco_passive_agent::type_id::create("passive_agent", this);
    	scoreboard = nco_scoreboard::type_id::create("scoreboard", this);
    	subscriber = nco_subscriber::type_id::create("coverage", this);
  endfunction:build_phase
  
  function void connect_phase(uvm_phase phase);    								   
    active_agent.active_monitor.item_collected_port.connect(scoreboard.active_mon_export);    // Connect active monitor transactions to scoreboard
    passive_agent.passive_monitor.item_collected_port.connect(scoreboard.passive_mon_export); // Connect passive monitor transactions to scoreboard    
    active_agent.active_monitor.item_collected_port.connect(subscriber.analysis_export);      // Connect active monitor to coverage subscriber
    passive_agent.passive_monitor.item_collected_port.connect(subscriber.pass_mon);          // Connect passive monitor to subscriber
  endfunction:connect_phase
endclass:nco_environment
