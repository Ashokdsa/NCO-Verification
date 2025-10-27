class nco_passive_monitor extends uvm_monitor;
  virtual nco_inf vif;
  uvm_analysis_port #(nco_sequence_item) item_collected_port;
  nco_sequence_item seq_item;

  `uvm_component_utils(nco_passive_monitor)

  function new (string name, uvm_component parent);
    super.new(name, parent);
    seq_item = new();
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual nco_inf)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction

  virtual task run_phase(uvm_phase phase);
    repeat(2)@(posedge vif.p_mon_cb);
   forever begin
     @(posedge vif.p_mon_cb);
      seq_item.wave_out = vif.p_mon_cb.wave_out;
      passive_ap.write(seq_item);
   end
  endtask
endclass
