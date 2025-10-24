// NCO Interface: defines DUT signal connections, clocking blocks, and protocol assertions
interface nco_inf(input bit clk);
	
   //------------------------------------------------------------------------------------------
  // DUT Signal Declarations
  //------------------------------------------------------------------------------------------

 //------------------------------------------------------------------------------------------
  // Clocking Blocks
  //------------------------------------------------------------------------------------------
  clocking drv_cb @(posedge clk);	// Driver clocking block
  endclocking
  
  clocking p_mon_cb@(posedge clk);	// Passive monitor clocking block
  endclocking
  
  clocking a_mon_cb@(posedge clk);	// Active monitor clocking block
  endclocking
  
  //------------------------------------------------------------------------------------------
  // Assertions
  //------------------------------------------------------------------------------------------
endinterface:nco_inf
