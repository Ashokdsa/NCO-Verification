// NCO Scoreboard collects transactions from both active and passive monitors via analysis imps.

`uvm_analysis_imp_decl(_passive)		//Analysis ipmlementation port declaration-passive monitor
`uvm_analysis_imp_decl(_active)			//Analysis ipmlementation port declaration-active monitor

class nco_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(nco_scoreboard)

  // Analysis implementation ports to receive transactions from monitors
  uvm_analysis_imp_active #(nco_sequence_item, nco_scoreboard) active_mon_export;
  uvm_analysis_imp_passive #(nco_sequence_item, nco_scoreboard) passive_mon_export;

  function new(string name="nco_scoreboard", uvm_component parent = null);
    super.new(name, parent);
    active_mon_export  = new("active_mon_export",  this);
    passive_mon_export = new("passive_mon_export", this);
  endfunction:new

//Write method for the active monitor 
  virtual function void write_active(nco_sequence_item item); 
  endfunction:write_active

 // Write method for the passive monitor 
  virtual function void write_passive(nco_sequence_item item1);
  endfunction:write_passive


  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask:run_phase

 //Report summary
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction:report_phase

endclass:nco_scoreboard
