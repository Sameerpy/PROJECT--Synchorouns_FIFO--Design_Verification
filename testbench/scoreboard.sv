class fifo_score extends uvm_scoreboard;
  `uvm_component_utils(fifo_score)

  uvm_analysis_imp#(fifo_trans, fifo_score) score_analysis_export;
  bit [7:0] expected_data_queue[$];

  int total_reads = 0;
  int match = 0;
  int mismatches = 0;
  bit pending_read;

  function new(string name = "fifo_score", uvm_component parent = null);
    super.new(name, parent);
    score_analysis_export = new("score_analysis_export", this);
  endfunction

  function void write(fifo_trans tr);
    if (tr.wn && !tr.full) begin
      expected_data_queue.push_back(tr.data_in);
      `uvm_info("FIFO_SCORE", $sformatf("ENQUEUED: %0h", tr.data_in), UVM_LOW)
    end
    
    if (tr.rn && !tr.empty) begin
      pending_read = 1'b1;
    end
    else if (pending_read) begin
      pending_read = 1'b0;
      total_reads++;

      if (expected_data_queue.size() == 0) begin
        mismatches++;
        `uvm_error("FIFO_SCORE", $sformatf("UNDERFLOW: Read occurred but queue empty. Observed: %0h", tr.data_out))
      end else begin
        bit [7:0] expected = expected_data_queue.pop_front();
        if (expected !== tr.data_out) begin
          mismatches++;
          `uvm_error("FIFO_SCORE", $sformatf("MISMATCH: Expected = %0h, Got = %0h", expected, tr.data_out))
        end else begin
          match++;
          `uvm_info("FIFO_SCORE", $sformatf("MATCH: Expected = %0h, Got = %0h", expected, tr.data_out), UVM_MEDIUM)
        end
      end
    end
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("FIFO_SCORE", $sformatf("Total Reads    : %0d", total_reads), UVM_LOW)
    `uvm_info("FIFO_SCORE", $sformatf("Matches        : %0d", match), UVM_LOW)
    `uvm_info("FIFO_SCORE", $sformatf("Mismatches     : %0d", mismatches), UVM_LOW)

    if (mismatches == 0)
      `uvm_info("FIFO_SCORE", "SCOREBOARD PASSED: All reads matched expected values", UVM_NONE)
    else
      `uvm_error("FIFO_SCORE", "SCOREBOARD FAILED: Mismatches found during read checks")
  endfunction
endclass

