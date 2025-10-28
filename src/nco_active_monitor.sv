class nco_active_monitor extends uvm_monitor;
  virtual nco_inf vif;  // Virtual interface handle for NCO interface
  uvm_analysis_port #(nco_sequence_item) item_collected_port;    // Analysis port
  nco_sequence_item seq_item;

  // Register this component with UVM factory
  `uvm_component_utils(nco_active_monitor)

  function new (string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction:new

  // Build phase: get interface and event handles from config DB
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual nco_inf)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction:build_phase

  virtual task run_phase(uvm_phase phase);
    repeat(2)@(posedge vif.a_mon_cb);
    forever 
    begin
      seq_item = new();
      @(posedge vif.a_mon_cb); 
      seq_item.signal_out = vif.a_mon_cb.signal_out;
      seq_item.resetn     = vif.a_mon_cb.resetn;
      item_collected_port.write(seq_item); 
    end
  endtask:run_phase
endclass:nco_active_monitor
