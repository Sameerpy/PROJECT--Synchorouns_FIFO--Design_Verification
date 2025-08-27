class base_seq extends uvm_sequence#(fifo_trans);
  `uvm_object_utils(base_seq)

  function new(string name = "base_seq");
    super.new(name);
  endfunction
  
  int num=50; 

  virtual task body();
    fifo_trans tr;
    repeat (num) begin
      `uvm_info("SEQ", "New Transaction Starts", UVM_MEDIUM)
      tr = fifo_trans::type_id::create("tr");
      if (!tr.randomize()) begin
        `uvm_error("BASE SEQ", "Randomization failed")
      end
      else begin
        `uvm_info("BASE SEQ", $sformatf("Generated: WN=%0b, RN=%0b, DATA_IN=0x%0h", tr.wn, tr.rn, tr.data_in), UVM_MEDIUM)
      end
      start_item(tr);
      finish_item(tr);
    end
  endtask

endclass
