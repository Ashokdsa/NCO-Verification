// NCO Interface: defines DUT signal connections, clocking blocks, and protocol assertions
`include "define.svh"
interface nco_inf(input bit clk);
	
   //------------------------------------------------------------------------------------------
  // DUT Signal Declarations
  //------------------------------------------------------------------------------------------
  logic resetn;
  logic [`SELECT_WIDTH-1:0] signal_out;
  logic [`WAVE_WIDTH-1:0] wave_out;

 //------------------------------------------------------------------------------------------
  // Clocking Blocks
  //------------------------------------------------------------------------------------------
  clocking drv_cb @(posedge clk);	// Driver clocking block
      default input #0 output #0;
      output signal_out;
      output resetn;
  endclocking
  
  clocking p_mon_cb@(posedge clk);	// Passive monitor clocking block
      default input #0 output #0;
      input wave_out;
      input resetn;
  endclocking
  
  clocking a_mon_cb@(posedge clk);	// Active monitor clocking block
      default input #0 output #0;
      input signal_out;
      input resetn;
  endclocking
  

    modport DRV (clocking drv_cb);
    modport ACT_MON (clocking a_mon_cb);
    modport PAS_MON (clocking p_mon_cb);
  //------------------------------------------------------------------------------------------
  // Assertions
  //------------------------------------------------------------------------------------------
endinterface:nco_inf
