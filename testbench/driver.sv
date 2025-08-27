class fifo_driv extends uvm_driver#(fifo_trans);
  `uvm_component_utils(fifo_driv)

  virtual fifo_if intf;
  logic do_wr;
  logic do_rd;

  function new(string name="fifo_driv", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_if", intf))
      `uvm_fatal("DRV", "Virtual interface not found!")
  endfunction

  virtual task run_phase(uvm_phase phase);
    reset_dut();
    forever begin
      drive_data();
    end
  endtask

  // --- Reset helper ---
  task reset_dut();
    `uvm_info("FIFO_DRV", "Applying Reset...", UVM_LOW)
    
    wait (intf.reset == 1);
    @(posedge intf.clock);
    intf.wn      <= 0;
    intf.rn      <= 0;
    intf.data_in <= '0;
    wait (intf.reset == 0);
    @(posedge intf.clock);
    
    `uvm_info("FIFO_DRV", "Reset De-asserted", UVM_LOW)
  endtask

  // --- Main driving ---
  task drive_data();
    fifo_trans it;
    seq_item_port.get_next_item(it);

    do_wr = it.wn && !intf.full;
    do_rd = it.rn && !intf.empty;

    intf.wn <= 0;
    intf.rn <= 0;

    if (do_wr && do_rd) begin
      // Simultaneous read and write (typical FIFO supports it)
      intf.data_in <= it.data_in;
      intf.wn <= 1;
      intf.rn <= 1;
      @(posedge intf.clock);
      intf.wn <= 0;
      intf.rn <= 0;

      // Read data from synchronous FIFO appears NEXT cycle
      @(posedge intf.clock);
      it.data_out = intf.data_out;

      `uvm_info("FIFO_DRV", $sformatf("WRITE+READ: WDATA=%0h, RDATA=%0h", it.data_in, it.data_out), UVM_MEDIUM)
    end
    else if (do_wr) begin
      intf.data_in <= it.data_in;
      intf.wn <= 1;
      @(posedge intf.clock);
      intf.wn <= 0;
      `uvm_info("FIFO_DRV", $sformatf("WRITE: Data = %0h", it.data_in), UVM_MEDIUM)
    end
    else if (do_rd) begin
      intf.rn <= 1;
      @(posedge intf.clock);
      intf.rn <= 0;

      // Extra cycle to allow synchronous read data to settle
      @(posedge intf.clock);
      it.data_out = intf.data_out;
      `uvm_info("FIFO_DRV", $sformatf("READ: Data = %0h", it.data_out), UVM_MEDIUM)
    end
    else begin
      `uvm_warning("FIFO_DRV", "Transaction skipped due to FIFO full/empty state")
    end

    // Return status back to sequencer item
    it.full  = intf.full;
    it.empty = intf.empty;

    seq_item_port.item_done();
  endtask
endclass
