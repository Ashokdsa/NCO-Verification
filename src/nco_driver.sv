class nco_driver extends uvm_driver #(nco_sequence_item);
  virtual nco_inf vif;
  `uvm_component_utils(nco_driver)
    
  function new (string name = "nco_driver", uvm_component parent);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual nco_inf)::get(this, "", "vif", vif))
      `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    repeat(1)@(posedge vif.drv_cb);
    forever begin
      seq_item_port.get_next_item(req); 
      drive();
      seq_item_port.item_done();
    end
  endtask

  virtual task drive();
       vif.signal_out<=req.signal_out;
    repeat(32)@(posedge vif.drv_cb);
  endtask
endclass
