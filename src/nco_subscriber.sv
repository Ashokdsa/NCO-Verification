// Subscriber for collecting functional coverage of NCO transactions

`uvm_analysis_imp_decl(_passive_mon)    // Declare a new analysis_imp for passive monitor connection

class nco_subscriber extends uvm_subscriber#(nco_sequence_item);
  `uvm_component_utils(nco_subscriber)    // Factory registration
  uvm_analysis_imp_passive_mon#(nco_sequence_item,nco_subscriber) pass_mon;      // Analysis implementation to connect passive monitor
  seq_item ip_pkt, out_pkt;
	
  covergroup input_cg;      // Input coverage group 
		c1 : coverpoint signal_out_cp;
		c2 : coverpoint reset_cp;
		c3 : cross c1, c2;
  endgroup:input_cg
  
  covergroup output_cg;     // Output coverage group
		c1 : coverpoint wave_out{
			bins sine = ();
			bins cosine = ();
			bins flat_zero = 0[*32];
			bins triangular = ();
			bins sinc = ();
			bins sawtooth = ();
			bins square = ();
			bins gaussian_chirplet = ();
			bins ecg = ();
		}
  endgroup:output_cg

  function new(string name = "subs", uvm_component parent = null);
    super.new(name,parent);
    input_cg = new();
    output_cg = new();
  endfunction:new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pass_mon = new("pass_mon",this);
  endfunction:build_phase

  virtual function void write(nco_sequence_item t);     // write() - receives transactions from the DRIVER
		ip_pkt = t;
   	input_cg.sample();
    `uvm_info(get_name,"[DRIVER]:INPUT RECIEVED",UVM_HIGH)
  endfunction:write

  virtual function void write_passive_mon(nco_sequence_item seq);     // write_passive_mon() - receives transactions from the PASSIVE monitor
		out_pkt = t;
    output_cg.sample();
    `uvm_info(get_name,"[MONITOR]:INPUT RECIEVED",UVM_HIGH)
  endfunction:write_passive_mon

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_name,$sformatf("INPUT COVERAGE = %0f\n OUTPUT COVERAGE = %0f",input_cg.get_coverage(),output_cg.get_coverage()),UVM_NONE);
  endfunction:report_phase

endclass:nco_subscriber
