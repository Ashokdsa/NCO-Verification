interface nco_assert(clk,resetn,signal_out,wave_out);
input bit clk;
input bit resetn;
input logic [`SELECT_WIDTH-1:0] signal_out;
input logic [`WAVE_WIDTH-1:0] wave_out;

property p1;
  @(posedge clk) 
  (!resetn) |-> (wave_out == 0);
endproperty


property p2;
  @(posedge clk) disable iff (!resetn)
    $changed(signal_out) |=> $stable(signal_out)[*31];
    //first_match($changed(signal_out) ##1 $stable(signal_out)[*31]);
endproperty

property p4;
  @(posedge clk or negedge clk) disable iff (!resetn)
    $changed(clk);
endproperty

property p5;
  @(posedge clk) disable iff (!resetn)
    $changed(signal_out) |-> ##2 $changed(wave_out);
endproperty

 Reset_trigger:assert property(p1)
    $display("PASSED Reset_trigger assertion");
  else
    $error("FAILED Reset_trigger assertion");

  Signal_Change:assert property(p2)
     $display("PASSED Signal_Change assertion");
  else
    $error("Failed Signal_Change assertion");

  Clock_Toggle:assert property(p4)
    $display("PASSED Clock Toggle assertion");
  else
    $error("Failed Clock Toggle assertion");

  /*
  Transition_time:assert property(p5)
     $display("PASSED Transition_time assertion");
  else
    $error("Failed Transition_time assertion");
  */

endinterface
  
