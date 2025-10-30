// NCO Scoreboard collects transactions from both active and passive monitors via analysis imps.
typedef enum {SINE,COSINE,TRIANGULAR,SINC,SAWTOOTH,SQUARE,GAUSSIAN_CHIRPLET,ECG}wave;

`uvm_analysis_imp_decl(_active)
`uvm_analysis_imp_decl(_passive)


class nco_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(nco_scoreboard)
  uvm_analysis_imp_active #(nco_sequence_item, nco_scoreboard) active_mon_export;
  uvm_analysis_imp_passive #(nco_sequence_item, nco_scoreboard) passive_mon_export;


  int match = 0;
  int mismatch = 0;
  int total_transactions = 0;

  bit [7:0] scb_sine_mem [0:31];
  bit [7:0] scb_cosine_mem [0:31];
  bit [7:0] scb_triangle_mem [0:31];
  bit [7:0] scb_sawtooth_mem [0:31];
  bit [7:0] scb_gaussian_mem [0:31];
  bit [7:0] scb_square_mem [0:31];
  bit [7:0] scb_sinc_mem [0:31];
  bit [7:0] scb_ecg_mem [0:31];

  bit [7:0] dut_mem [0:31];
  bit [7:0] expected_mem [0:31];
  int dut_count = 0;

  nco_sequence_item a_mon_queue[$];
  bit scb_mem_generated = 0;

  function new(string name = "nco_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    active_mon_export  = new("active_mon_export",  this);
    passive_mon_export = new("passive_mon_export", this);
    // Generate reference waveforms
    generate_reference_waveforms();
  endfunction

  // ---------- Power function ----------
  function automatic real power(input real base, input int exp);
    real result = 1.0;
    int abs_exp = (exp < 0) ? -exp : exp;

    for (int i = 0; i < abs_exp; i++)
      result *= base;

    if (exp < 0)
      return 1.0 / result;
    else
      return result;
  endfunction

  // ---------- Factorial task ----------
  task automatic factorial(input int n, output real fact);
    fact = 1.0;
    if (n < 0) begin
      `uvm_error(get_type_name(), "Negative factorial not defined")
      fact = 0.0;
      return;
    end
    for (int i = 2; i <= n; i++)
      fact *= i;
  endtask

  // ---------- X value generation ----------
  task automatic x_val(input int n, input real range, output real x);
    real pi = 3.141592653589793;
    x = (2.0 * pi * n) / range;
  endtask

  // ---------- X value generation for sinc ----------
  task automatic x_sinc(input int n, input real range, output real x);
    real pi = 3.141592653589793;
    int half_range = range / 2;
    x = (3.0 * pi * (n - half_range)) / half_range; // full 0–2π range for one sine cycle
  endtask

  // ---------- Rounding ----------
  function automatic int round(input real val);
    int lower = int'(val);
    real frac = val - lower;

    if (frac > 0.5)
      return lower + 1;
    else if (frac < 0.5)
      return lower;
    else
      return (lower % 2 == 0) ? lower : lower + 1;
  endfunction

  // ---------- Sine computation ----------
  task automatic sine_function(input real x, output real sine);
    real fact, term;
    int max_terms = 20;
    sine = 0.0;

    for (int i = 0; i < max_terms; i++) begin
      factorial(2*i + 1, fact);
      term = power(-1.0, i) * (power(x, 2*i + 1) / fact);
      sine += term;
    end
  endtask

  // ---------- Sine wave output ----------
  task automatic sine_wave_out(input real sine, input int n, output int value);
    real val;
    //sine values from [-1,1] convert that to [0.255]
    val = ((sine + 1.0) * 127.5);
    value = round(val);

    // if (n == 0 || n == 16)
      // value = 128;
    // else if (n == 8)
      // value = 255;
    // else if (n == 24)
      // value = 0;

    if (value < 0) value = 0;
    if (value > 255) value = 255;
  endtask

  // ---------- Cosine computation ----------
  task automatic cosine_function(input real x, output real cosine);
    real fact, term;
    int max_terms = 20;
    cosine = 0.0;

    for (int i = 0; i < max_terms; i++) begin
      factorial(2*i, fact);
      term = power(-1.0, i) * (power(x, 2*i) / fact);
      cosine += term;
    end
  endtask

  // ---------- Cosine wave output ----------
  task automatic cosine_wave_out(input real cosine, input int n, output int value);
    real val;
    val = ((cosine + 1.0) * 127.5);
    value = round(val);

    // if (n == 0)
      // value = 255;
    // else if (n == 8 || n == 24)
      // value = 128;
    // else if (n == 16)
      // value = 0;

    if (value < 0) value = 0;
    if (value > 255) value = 255;
  endtask

  // ---------- Triangle wave ----------
  task automatic triangle_wave_out(input int n, input int range, output int tri_out);
    real half_range = range / 2.0;
    real val;
    if (n < half_range)
      val = (255.0 * n) / half_range;
    else 
      val = (255.0 * (range - n)) / half_range;

    tri_out = round(val);
  endtask

  // ---------- Sawtooth wave ----------
  task automatic sawtooth_wave_out(input int n, input int range, output int saw_out);
    real val;
    val = (255.0 * n) / (range);
    saw_out = round(val);
  endtask

  // ---------- Square wave ----------
  task automatic square_wave_out(input int n, input int range, output int sq_out);
    int half_range = range / 2;
    int idx = n % range;

    if (idx < half_range)
      sq_out = 255;
    else
      sq_out = 0;
  endtask

  // ---------- Sinc value computation (Taylor expansion) ----------
  task automatic sinc_function(input real x, output real sinc);
    real fact, term, temp;
    int max_terms = 20; // Increased to 15 terms (up to x^29/29!)

    for (int i = 0; i < max_terms; i++) begin
      factorial(2*i + 1, fact);
      term = power(-1.0, i) * (power(x, 2*i + 1) / fact);
      temp += term;
    end
    if(x != 0)
      sinc = temp / x;
    else
      sinc = 1;
  endtask

  // ---------- Convert sine output to 8-bit digital value ----------
  task automatic sinc_wave_out(input real sinc,input int n, output int value);
    real val;
    // Shift from [-1, 1] → [0, 255]
    val = ((sinc + 1.0) * 127.5);  // More precise: 255/2 = 127.5
    value = round(val);

    //        if (n == 0 || n == 16)
    //         value = 128;
    //     else if (n == 8)
    //         value = 255;
    //     else if (n == 24)
    //         value = 0;

    // Clamp to valid 8-bit range
    if (value < 0) value = 0;
    if (value > 255) value = 255;
  endtask

  // gaussian ecg and sync 

  function void generate_reference_waveforms();
    real sine, cosine, sinc, x;
    int temp_val;

    `uvm_info(get_type_name(), "Generating reference waveforms...", UVM_MEDIUM)

    scb_ecg_mem = '{72,73,76,83,88,83,76,73,72,59,255,0,72,72,73,76,83,95,111,125,131,125,111,95,83,76,73,72,72,72,72,72};
    scb_sinc_mem = '{122, 130, 138, 143, 143, 137, 125, 112, 102, 100, 109, 130, 160, 194, 225, 247, 255, 247, 225, 194, 160, 130, 109, 100, 102, 112, 125, 137, 143, 143, 138, 130};

    // Generate all 5 waveforms
    for (int n = 0; n < 32; n++) begin
      // Sine wave
      x_val(n, 32.0, x);
      sine_function(x, sine);
      sine_wave_out(sine, n, temp_val);
      scb_sine_mem[n] = temp_val[7:0];

      // Cosine wave
      cosine_function(x, cosine);
      cosine_wave_out(cosine, n, temp_val);
      scb_cosine_mem[n] = temp_val[7:0];

      // Triangle wave
      triangle_wave_out(n, 32, temp_val);
      scb_triangle_mem[n] = temp_val[7:0];

      // Sawtooth wave
      sawtooth_wave_out(n, 32, temp_val);
      scb_sawtooth_mem[n] = temp_val[7:0];

      // Square wave
      square_wave_out(n, 32, temp_val);
      scb_square_mem[n] = temp_val[7:0];

      // Sinc wave 
      // x_sinc(n, 32.0, x);
      // sinc_function(x, sinc);
      // sinc_wave_out(sinc, n, temp_val);
      // scb_sinc_mem[n] = temp_val[7:0];
    end

    for (int j = 0; j < 32; j++) begin
      if(j%2)
        scb_gaussian_mem[j]=scb_sine_mem[31-j/2];
      else
        scb_gaussian_mem[j]=scb_sine_mem[j/2];
    end
    scb_mem_generated = 1;
    `uvm_info(get_type_name(), "Reference waveforms generated successfully", UVM_MEDIUM)
    $display("SINE COSINE SQUARE TRIANGLE SAWTOOTH ECG GAUSSIAN SINC");
    foreach(scb_sine_mem[i])
      $display("%0d\t%0d\t%0d\t%0d\t%0d\t%0d\t%0d\t%0d",scb_sine_mem[i],scb_cosine_mem[i],scb_square_mem[i],scb_triangle_mem[i],scb_sawtooth_mem[i],scb_ecg_mem[i],scb_gaussian_mem[i],scb_sinc_mem[i]);
  endfunction

  wave wave_name;

  virtual function void write_active(nco_sequence_item a_transaction); 
    // Store transaction from active monitor
    nco_sequence_item a_trans = a_transaction;
    wave_name = wave'(a_trans.signal_out);
    a_mon_queue.push_back(a_trans);

    `uvm_info(get_type_name(), 
      $sformatf("Active Monitor: Received signal_out=%0d, reset=%0b", 
      a_trans.signal_out, a_trans.resetn), 
      UVM_HIGH)

  endfunction:write_active


  virtual function void write_passive(nco_sequence_item p_trans);
    nco_sequence_item a_trans = new();

    if(a_mon_queue.size())
      a_trans = a_mon_queue.pop_front();

    if (a_trans.resetn == 1'b0) begin
      total_transactions++;
      if (p_trans.wave_out == 8'h00) begin
        match++;
        `uvm_info(get_type_name(), 
          $sformatf("RESET MATCH: DUT output=0x%0h (Expected 0x00 during reset)", 
          p_trans.wave_out), 
          UVM_MEDIUM)
      end 
      else begin
        mismatch++;
        `uvm_error(get_type_name(), 
          $sformatf("RESET MISMATCH: DUT output=0x%0h (Expected 0x00 during reset)", 
          p_trans.wave_out))
      end

      // Reset sample counter when reset is asserted
      dut_count = 0;
      foreach(dut_mem[i]) begin
        dut_mem[i]=8'd0;
        expected_mem[i]=8'd0;
      end
      `uvm_info(get_type_name(), "Sample counter reset to 0 due to reset assertion", UVM_HIGH)
    end
    else begin
      // Store DUT output (only if not in reset)
      if (dut_count < 32 ) begin
        dut_mem[dut_count] = p_trans.wave_out;

        // Select expected value based on signal_out
        $display("---------PTR = %0d-----------",dut_count);
        case (a_trans.signal_out)
          3'd0: begin
            expected_mem[dut_count] = scb_sine_mem[dut_count];
            $display("---------------------------OUT = %0d-------------------------------",scb_sine_mem[dut_count]);
          end
          3'd1: begin
            expected_mem[dut_count] = scb_cosine_mem[dut_count];
            $display("---------------------------OUT = %0d-------------------------------",scb_cosine_mem[dut_count]);
          end
          3'd2: begin
            expected_mem[dut_count] = scb_triangle_mem[dut_count];
            $display("---------------------------OUT = %0d-------------------------------",scb_triangle_mem[dut_count]);
          end
          3'd4: begin
            expected_mem[dut_count] = scb_sawtooth_mem[dut_count];
            $display("---------------------------OUT = %0d-------------------------------",scb_sawtooth_mem[dut_count]);
          end
          3'd5: begin
            expected_mem[dut_count] = scb_square_mem[dut_count];
            $display("---------------------------OUT = %0d-------------------------------",scb_square_mem[dut_count]);
          end
          3'd3: begin
            expected_mem[dut_count] = scb_sinc_mem[dut_count];
            $display("---------------------------OUT = %0d-------------------------------",scb_sinc_mem[dut_count]);
          end
          3'd7: begin
            expected_mem[dut_count] = scb_ecg_mem[dut_count];
            $display("---------------------------OUT = %0d-------------------------------",scb_ecg_mem[dut_count]);
          end
          3'd6: begin
            expected_mem[dut_count] = scb_gaussian_mem[dut_count];
            $display("---------------------------OUT = %0d-------------------------------",scb_gaussian_mem[dut_count]);
          end
          default: begin
            `uvm_warning(get_type_name(), 
              $sformatf("Unknown signal_out=%0d", a_trans.signal_out))
          end
        endcase
      end
      else begin
        dut_count = 0;
        foreach(dut_mem[i]) begin
          dut_mem[i]=0;
          expected_mem[i]=0;
        end
      end
      total_transactions++;
      dut_count++;

      // compare logic 
      if (dut_count==32) begin
        $display("COMPARE RESULTS");
        for(int i=0;i<32;i++) begin
          if (dut_mem[i] inside {expected_mem[i]-1,expected_mem[i],expected_mem[i]+1}) begin
            //match++;
            `uvm_error(get_type_name(), 
              $sformatf("MATCH [%s][%0d]: DUT=%3d | Expected=%3d", 
              wave_name, dut_count, dut_mem[i], expected_mem[i]))
          end
          else begin
            //mismatch++;
            `uvm_info(get_type_name(), 
              $sformatf("MISMATCH [%s][%0d]: DUT=%3d | Expected=%3d", 
              wave_name, dut_count, dut_mem[i], expected_mem[i]), 
              UVM_MEDIUM)
          end
        end
      end
    end
  endfunction:write_passive
endclass
