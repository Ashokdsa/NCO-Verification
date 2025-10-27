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
endclass

class nco_normal_sequence extends nco_sequence; //CHECKS ALL THE WAVEFORMS
  `uvm_object_utils(nco_normal_sequence)

  function new(string name = "nco_normal_sequence");
    super.new(name);
  endfunction

  task body();
    seq = nco_sequence_item::type_id::create("seq");
    seq.resetn = 1;
    repeat(7) begin
      wait_for_grant();
      assert(seq.randomize());
      send_request(seq);
      wait_for_item_done();
    end
  endtask
endclass

class nco_cont_sequence extends nco_sequence; //CHECKS FOR THE REPEATABILITY
  `uvm_object_utils(nco_cont_sequence)

  function new(string name = "nco_cont_sequence");
    super.new(name);
  endfunction

  task body();
    seq = nco_sequence_item::type_id::create("seq");
    seq.resetn = 1;
    seq.signal_out = 0;
    repeat(7) begin
      assert(seq.randomize());
      repeat(2) begin
        wait_for_grant();
        send_request(seq);
        wait_for_item_done();
      end
    end
  endtask
endclass

class nco_reset_normal_sequence#(int cnt = 1, int signal = 0) extends nco_sequence; //GIVES A RESET
  `uvm_object_param_utils(nco_reset_normal_sequence#(cnt,signal))

  function new(string name = "nco_reset_normal_sequence");
    super.new(name);
  endfunction

  task body();
    repeat(cnt) begin
      seq = nco_sequence_item::type_id::create("seq");
      wait_for_grant();
      seq.signal_out = signal;
      seq.resetn = 0;
      send_request(seq);
      wait_for_item_done();
    end
  endtask
endclass

class nco_no_inp_sequence#(int cnt = 1) extends nco_sequence; //NO INPUT IS SENT CAUSING OUTPUT TO BE IN QUIET STATE
  `uvm_object_param_utils(nco_no_inp_sequence#(cnt))

  function new(string name = "nco_no_inp_sequence");
    super.new(name);
  endfunction

  task body();
    repeat(cnt) begin
      seq = nco_sequence_item::type_id::create("seq");
      wait_for_grant();
      seq.rand_mode(0);
      seq.resetn = 1;
      send_request(seq);
      wait_for_item_done();
    end
  endtask
endclass

class nco_change_req_sequence extends nco_sequence; //CHANGE IN REQUEST
  `uvm_object_utils(nco_change_req_sequence)

  function new(string name = "nco_change_req_sequence");
    super.new(name);
  endfunction

  task body();
    seq = nco_sequence_item::type_id::create("seq");
    seq.resetn = 1;
    repeat(7) begin
      //RESTART THE BIT
      repeat(2) begin
        wait_for_grant();
        assert(seq.randomize());
        //CHANGE IN SIGNAL MUST BE DONE IN BETWEEN INDICATED BY A BIT
        send_request(seq);
        wait_for_item_done();
      end
    end
  endtask
endclass

class nco_reset_change_sequence extends nco_sequence; //TRIGGER OF RESET BETWEEN REQUEST
  `uvm_object_utils(nco_reset_change_sequence)

  function new(string name = "nco_reset_change_sequence");
    super.new(name);
  endfunction

  task body();
    seq = nco_sequence_item::type_id::create("seq");
    repeat(7) begin

      wait_for_grant();
      //RESET IN BETWEEN IN MUST BE DONE IN BETWEEN INDICATED BY A BIT
      assert(seq.randomize());
      seq.resetn = 0;
      send_request(seq);
      //RESET HAS BEEN GIVEN IN BETWEEN
      wait_for_item_done();
      
      //SEQUENCE CONTINUES NORMALLY
      wait_for_grant();
      seq.resetn = 1;
      send_request(seq);
      wait_for_item_done();
    end
  endtask
endclass

class nco_reset_diff_sequence#(int cnt = 16) extends nco_sequence; //TRIGGER OF RESET BETWEEN REQUEST FOLLOWED BY CHANGE IN SIGNAL_OUT
  bit [(`SELECT_WIDTH-1):0] signal;
  bit [(`SELECT_WIDTH-1):0] done[$];
  `uvm_object_param_utils(nco_reset_diff_sequence#(cnt))

  function new(string name = "nco_reset_diff_sequence");
    super.new(name);
  endfunction

  task body();
    seq = nco_sequence_item::type_id::create("seq");
    repeat(cnt) begin

      wait_for_grant();
      //RESET IN BETWEEN IN MUST BE DONE IN BETWEEN INDICATED BY A BIT
      seq.signal_out = signal;
      seq.resetn = 0;
      send_request(seq);
      //RESET HAS BEEN GIVEN IN BETWEEN
      wait_for_item_done();
      
      //SEQUENCE CHANGES
      wait_for_grant();
      assert(seq.randomize() with {seq.signal_out != signal;});
      seq.resetn = 1;
      done.push_back(seq.signal_out);
      if(done.size() >= 7)
      begin
        signal = signal < 8 ? signal+1 : 0;
        while(done.size())
          void'(done.pop_front());
      end
      send_request(seq);
      wait_for_item_done();
    end
  endtask

endclass
