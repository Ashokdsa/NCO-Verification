// Subscriber for collecting functional coverage of NCO transactions

`uvm_analysis_imp_decl(_passive_mon)    // Declare a new analysis_imp for passive monitor connection

class nco_subscriber extends uvm_subscriber#(nco_sequence_item);
  `uvm_component_utils(nco_subscriber)    // Factory registration
  uvm_analysis_imp_passive_mon#(nco_sequence_item,nco_subscriber) pass_mon;      // Analysis implementation to connect passive monitor
  nco_sequence_item ip_pkt, out_pkt;
  bit flat;
	
  covergroup input_cg;      // Input coverage group 
		signal_out_cp : coverpoint ip_pkt.signal_out;
		resetn_cp : coverpoint ip_pkt.resetn;
		signali_outxresetn : cross signal_out_cp, resetn_cp;
  endgroup:input_cg
  
  covergroup output_cg;     // Output coverage group
   	cg_waveforms : coverpoint out_pkt.wave_out {
    	// Sine wave transitions (smooth curve)
    	bins sine = (128 => 152 => 176 => 198 => 218 => 234 => 245 => 253 => 255 => 253 => 245 => 234 => 218 => 198 => 176 => 152 => 128 => 103 => 79 => 57 => 37 => 21 => 10 => 2 => 0 => 2 => 10 => 21 => 37 => 57 => 79 => 103 => 128);
    
    	// Cosine wave transitions (phase-shifted sine)
    	bins cosine = (255 => 253 => 245 => 234 => 218 => 198 => 176 => 152 => 128 => 103 => 79 => 57 => 37 => 21 => 10 => 2 => 0 => 2 => 10 => 21 => 37 => 57 => 79 => 103 => 127 => 152 => 176 => 198 => 218 => 234 => 245 => 253 => 255);
    
    	// Flat zero (all zeros)
    	bins flat_zero = {0} iff(flat);
    
    	// Triangular wave transitions (linear ramp)
    	bins triangular = (0 => 16 => 32 => 48 => 64 => 80 => 96 => 112 => 128 => 143 => 159 => 175 => 191 => 207 => 223 => 239 => 255 => 239 => 223 => 207 => 191 => 175 => 159 => 143 => 128 =>112 => 96 => 80 => 64 => 48 => 32 => 16 => 0);
    
    	// Sinc function transitions (oscillatory decay)
    	bins sinc = (122 => 130 => 138 => 143 => 143 => 137 => 125 => 112 => 102 => 100 => 109 => 130 => 160 => 194 => 225 => 247 => 255 => 247 => 225 => 194 => 160 => 130 => 109 => 100 => 102 => 112 => 125 => 137 => 143 => 143 => 138 => 130 => 122);
    
    	// Sawtooth wave transitions (linear increasing)
    	bins sawtooth = (0 => 8 => 16 => 24 => 32 => 40 => 48 => 56 => 64 => 72 => 80 => 88 => 96 => 104 => 112 => 120 => 128 => 135 => 143 => 151 => 159 => 167 => 175 => 183 => 191 => 199 => 207 => 215 => 223 => 231 => 239 => 247);
    
    	// Square wave transitions (high then low)
    	bins square = (255 => 255 => 255 => 255 => 255 => 255 => 255 => 255 => 255 => 255 => 255 => 255 => 255 => 255 => 255 => 255 => 0 => 0 => 0 => 0 => 0 => 0 => 0 => 0 => 0 => 0 => 0 => 0 => 0 => 0 => 0 => 0);
    
    	// Gaussian chirplet transitions (complex pattern)
    	bins gaussian_chirplet = (128 => 103 => 152 => 79 => 176 => 57 => 198 => 37 => 218 => 21 => 234 => 10 => 245 => 2 => 253 => 0 => 255 => 2 => 253 => 10 => 245 => 21 => 234 => 37 => 218 => 57 => 198 => 79 => 176 => 103 => 152 => 128);
    
    	// ECG waveform transitions (heartbeat pattern)
    	bins ecg = (72 => 73 => 76 => 83 => 88 => 83 => 76 => 73 => 72 => 59 => 255 => 0 => 72 => 72 => 73 => 76 => 83 => 95 => 111 => 125 => 131 => 125 => 111 => 95 => 83 => 76 => 73 => 72 => 72 => 72 => 72 => 72);
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
    flat = ip_pkt.resetn && $isunknown(ip_pkt.signal_out);
   	input_cg.sample();
    `uvm_info(get_name,"[DRIVER]:INPUT RECIEVED",UVM_HIGH)
  endfunction:write

  virtual function void write_passive_mon(nco_sequence_item seq);     // write_passive_mon() - receives transactions from the PASSIVE monitor
		out_pkt = seq;
    output_cg.sample();
    `uvm_info(get_name,"[MONITOR]:INPUT RECIEVED",UVM_HIGH)
  endfunction:write_passive_mon

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_name,$sformatf("INPUT COVERAGE = %0f\n OUTPUT COVERAGE = %0f",input_cg.get_coverage(),output_cg.get_coverage()),UVM_NONE);
  endfunction:report_phase

endclass:nco_subscriber
