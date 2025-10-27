class nco_driver extends uvm_driver #(nco_sequence_item);
  virtual nco_inf vif;
  int reset_val;
  int sig_out_val;
  int total;
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
    repeat(2)@(posedge vif.drv_cb);
    forever begin
      seq_item_port.get_next_item(req); 
      drive();
      seq_item_port.item_done();
    end
  endtask

  virtual task drive();
    //    vif.signal_out<=req.signal_out;
    // repeat(32)@(posedge vif.drv_cb);

    if(req.resetn)//rstn==1 
    begin
      if(req.in_btw)
      begin//1
        vif.drv_cb.resetn<=1;
        vif.drv_cb.signal_out<=req.signal_out;

        sig_out_val=$urandom_range(5,20);
        total=32-sig_out_val;   //need to parameterize this"32"

        repeat(sig_out_val)@(posedge vif.drv_cb);

        seq_item_port.item_done();
        seq_item_port.get_next_item(req);
        vif.drv_cb.signal_out<=req.signal_out;
        repeat(total)@(posedge vif.drv_cb);

      end//1
      else
      begin
        vif.drv_cb.signal_out<=req.signal_out;
        repeat(32)@(posedge vif.drv_cb);
      end
    end
    else//rst=0 asserted
    begin
      vif.drv_cb.signal_out<=req.signal_out;
      if(req.in_btw)
      begin//0
        reset_val=$urandom_range(5,20);

        for(int i=0;i<32;i++)
        begin//1
          @(posedge vif.drv_cb);
          if(i==reset_val)
          begin//2
            vif.drv_cb.resetn<=1'b0;
            repeat(5)@(posedge vif.drv_cb);
            vif.resetn<=1'b1;
            repeat(32)
            @(posedge vif.drv_cb);

            break;      //exit frm for loop
          end//2
        end//1
      end//0
      else
      begin
        vif.drv_cb.resetn<=1'b0;
        repeat(2)@(posedge vif.drv_cb);
      end
    end
  endtask
endclass
