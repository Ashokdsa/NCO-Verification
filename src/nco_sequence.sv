class nco_sequence extends uvm_sequence#(nco_sequence_item); //BASE sequence
  `uvm_object_utils(nco_sequence)    //Factory Registration
  nco_sequence_item seq;

  function new(string name = "nco_sequence");
    super.new(name);
  endfunction:new

  task body();
    `uvm_do_with(seq,
    {
      seq.resetn == 1;
      seq.signal_out inside {[0:7]};
    })
  endtask
endclass:nco_sequence

class nco_normal_sequence extends nco_sequence; //CHECKS ALL THE WAVEFORMS
  `uvm_object_utils(nco_normal_sequence)

  function new(string name = "nco_normal_sequence");
    super.new(name);
  endfunction

  task body();
    $display("nco_normal_test");
    seq = nco_sequence_item::type_id::create("seq");
    seq.resetn = 1;
    seq.in_btw = 0;
    repeat(8) begin
      wait_for_grant();
      assert(seq.randomize());
      send_request(seq);
      wait_for_item_done();
    end
  endtask
endclass:nco_normal_sequence

class nco_cont_sequence extends nco_sequence; //CHECKS FOR THE REPEATABILITY
  `uvm_object_utils(nco_cont_sequence)

  function new(string name = "nco_cont_sequence");
    super.new(name);
  endfunction

  task body();
    $display("nco_cont_Seq_test");
    seq = nco_sequence_item::type_id::create("seq");
    seq.resetn = 1;
    seq.in_btw = 0;
    seq.signal_out = 0;
    repeat(8) begin
      assert(seq.randomize());
      repeat(2) begin
        wait_for_grant();
        send_request(seq);
        wait_for_item_done();
      end
    end
  endtask
endclass:nco_cont_sequence

class nco_reset_normal_sequence#(int cnt = 1, int signal = 0) extends nco_sequence; //GIVES A RESET
  `uvm_object_param_utils(nco_reset_normal_sequence#(cnt,signal))

  function new(string name = "nco_reset_normal_sequence");
    super.new(name);
  endfunction

  task body();
    $display("nco_reset_normal_test");
    repeat(cnt) begin
      seq = nco_sequence_item::type_id::create("seq");
      wait_for_grant();
      seq.in_btw = 0;
      seq.signal_out = signal;
      seq.resetn = 0;
      send_request(seq);
      wait_for_item_done();
    end
  endtask
endclass:nco_reset_normal_sequence

class nco_no_inp_main_sequence#(int cnt = 1) extends nco_sequence; //NO INPUT IS SENT CAUSING OUTPUT TO BE IN QUIET STATE
  `uvm_object_param_utils(nco_no_inp_main_sequence#(cnt))

  function new(string name = "nco_no_inp_main_sequence");
    super.new(name);
  endfunction

  task body();
    $display("nco_no_inp_test");
    repeat(cnt) begin
      seq = nco_sequence_item::type_id::create("seq");
      seq.rand_mode(0);

      seq.in_btw = 0;
      seq.signal_out = 1;
      wait_for_grant();
      seq.resetn = 1;
      send_request(seq);
      wait_for_item_done();

      seq = nco_sequence_item::type_id::create("seq");
      seq.rand_mode(0);
      seq.in_btw = 0;
      wait_for_grant();
      seq.resetn = 1;
      send_request(seq);
      wait_for_item_done();
    end
  endtask
endclass:nco_no_inp_main_sequence

class nco_no_inp_sequence#(int cnt = 1) extends nco_sequence; //NO INPUT IS SENT CAUSING OUTPUT TO BE IN QUIET STATE
  `uvm_object_param_utils(nco_no_inp_sequence#(cnt))

  function new(string name = "nco_no_inp_sequence");
    super.new(name);
  endfunction

  task body();
    $display("nco_no_inp2_test");
    repeat(cnt) begin
      seq = nco_sequence_item::type_id::create("seq");
      seq.rand_mode(0);

      seq.in_btw = 0;
      wait_for_grant();
      seq.resetn = 1;
      send_request(seq);
      wait_for_item_done();
    end
  endtask
endclass:nco_no_inp_sequence

class nco_change_req_sequence#(int cnt = 56) extends nco_sequence; //CHANGE IN REQUEST
  bit [(`SELECT_WIDTH-1):0] signal;
  bit [(`SELECT_WIDTH-1):0] done[$];
  `uvm_object_utils(nco_change_req_sequence)

  function new(string name = "nco_change_req_sequence");
    super.new(name);
  endfunction

  task body();
    $display("nco_req_change_test");
    seq = nco_sequence_item::type_id::create("seq");
    seq.resetn = 1;
    signal = 0;
    repeat(cnt) begin

      wait_for_grant();
      seq.resetn = 1;
      seq.signal_out = signal;
      seq.in_btw = 1;
      send_request(seq);
      wait_for_item_done();
      seq.in_btw = 0;

      wait_for_grant();
      assert(seq.randomize() with {seq.signal_out != signal;});
      seq.resetn = 1;
      seq.in_btw = 1;
      done.push_back(seq.signal_out);
      if(done.size() >= 7)
      begin
        signal = signal < 7 ? signal+1 : 0;
        while(done.size())
          void'(done.pop_front());
      end
      send_request(seq);
      wait_for_item_done();
    end
  endtask
endclass:nco_change_req_sequence

class nco_reset_change_sequence extends nco_sequence; //TRIGGER OF RESET BETWEEN REQUEST
  `uvm_object_utils(nco_reset_change_sequence)

  function new(string name = "nco_reset_change_sequence");
    super.new(name);
  endfunction

  task body();
    $display("nco_reset_change_test");
    seq = nco_sequence_item::type_id::create("seq");
    repeat(8) begin

      wait_for_grant();
      //RESET IN BETWEEN IN MUST BE DONE IN BETWEEN INDICATED BY A BIT
      assert(seq.randomize());
      seq.resetn = 0;
      seq.in_btw = 1;
      send_request(seq);
      //RESET HAS BEEN GIVEN IN BETWEEN
      wait_for_item_done();
    end
  endtask
endclass:nco_reset_change_sequence

class nco_reset_diff_sequence#(int cnt = 16) extends nco_sequence; //TRIGGER OF RESET BETWEEN REQUEST FOLLOWED BY CHANGE IN SIGNAL_OUT
  bit [(`SELECT_WIDTH-1):0] signal;
  bit [(`SELECT_WIDTH-1):0] done[$];
  `uvm_object_param_utils(nco_reset_diff_sequence#(cnt))

  function new(string name = "nco_reset_diff_sequence");
    super.new(name);
  endfunction

  task body();
    $display("nco_reset_diff_test");
    seq = nco_sequence_item::type_id::create("seq");
    repeat(cnt) begin

      wait_for_grant();
      seq.in_btw = 1;
      seq.signal_out = signal;
      seq.resetn = 0;
      send_request(seq);
      //RESET HAS BEEN GIVEN IN BETWEEN
      wait_for_item_done();
      
      //SEQUENCE CHANGES
      wait_for_grant();
      assert(seq.randomize() with {seq.signal_out != signal;});
      seq.in_btw = 0;
      seq.resetn = 1;
      done.push_back(seq.signal_out);
      if(done.size() >= 7)
      begin
        signal = signal < 7 ? signal+1 : 0;
        while(done.size())
          void'(done.pop_front());
      end
      send_request(seq);
      wait_for_item_done();
    end
  endtask

endclass:nco_reset_diff_sequence

class nco_regress_sequence extends nco_sequence; //REGRESSION TEST
  nco_normal_sequence seq1;
  nco_cont_sequence seq2;
  nco_reset_normal_sequence#(1,1) seq3;
  nco_no_inp_sequence#(1) seq4;
  nco_change_req_sequence#(56) seq5;
  nco_reset_change_sequence seq6;
  nco_reset_diff_sequence#(56) seq7;
  `uvm_object_param_utils(nco_regress_sequence)

  function new(string name = "nco_regress_sequence");
    super.new(name);
  endfunction

  task body();
    $display("nco_regression_test");
    `uvm_do(seq4)
    `uvm_do(seq1)
    `uvm_do(seq2)
    `uvm_do(seq3)
    `uvm_do(seq5)
    `uvm_do(seq6)
    `uvm_do(seq7)
  endtask

endclass:nco_regress_sequence
