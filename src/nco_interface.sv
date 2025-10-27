// NCO Interface: defines DUT signal connections, clocking blocks, and protocol assertions
interface nco_inf(input bit clk);
	
   //------------------------------------------------------------------------------------------
  // DUT Signal Declarations
  //------------------------------------------------------------------------------------------
  logic [`SELECT_WIDTH-1:0] signal_out;
  logic [`WAVE_WIDTH-1:0] wave_out;

 //------------------------------------------------------------------------------------------
  // Clocking Blocks
  //------------------------------------------------------------------------------------------
  clocking drv_cb @(posedge clk);	// Driver clocking block
      default input #0 output #0;
      output signal_out;
  endclocking
  
  clocking p_mon_cb@(posedge clk);	// Passive monitor clocking block
      default input #0 output #0;
      input wave_out;
  endclocking
  
  clocking a_mon_cb@(posedge clk);	// Active monitor clocking block
      default input #0 output #0;
      input signal_out;
  endclocking
  
  //------------------------------------------------------------------------------------------
  // Assertions
  //------------------------------------------------------------------------------------------
endinterface:nco_inf
