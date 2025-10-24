// Passive NCO agent class which instantiates only passive monitor

class nco_passive_agent extends uvm_agent;
  nco_passive_monitor  passive_monitor;    // Passive monitor instance declaration

  // Registering the component with the factory
  `uvm_component_utils(nco_passive_agent)

  function new (string name = "nco_passive_agent", uvm_component parent);
    super.new(name, parent);
  endfunction:new

  function void build_phase(uvm_phase phase);
    passive_monitor = nco_passive_monitor::type_id::create("passive_monitor", this);
  endfunction:build_phase
endclass:nco_passive_agent
