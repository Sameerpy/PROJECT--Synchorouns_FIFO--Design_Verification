class fifo_mon extends uvm_monitor;
  `uvm_component_utils(fifo_mon)

  virtual fifo_if intf;
  fifo_trans tx;
  uvm_analysis_port#(fifo_trans) mon_analysis_port;

  function new(string name = "fifo_mon", uvm_component parent = null);
    super.new(name, parent);
    mon_analysis_port = new("mon_analysis_port", this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_if", intf))
      `uvm_fatal("MON", "Virtual interface not found!")
  endfunction

  virtual task run_phase(uvm_phase phase);
    `uvm_info("FIFO_MON", "Monitor started...", UVM_LOW)

    forever begin
      @(posedge intf.clock);
      tx = fifo_trans::type_id::create("tx", this);
      tx.wn       = intf.wn;
      tx.rn       = intf.rn;
      tx.data_in  = intf.data_in;
      tx.data_out = intf.data_out; 
      tx.full     = intf.full;
      tx.empty    = intf.empty;

      mon_analysis_port.write(tx);

      if (tx.wn && !tx.full)
        `uvm_info("FIFO_MON", $sformatf("Observed WRITE: Data = %0h", tx.data_in), UVM_MEDIUM)
      if (tx.rn && !tx.empty)
        `uvm_info("FIFO_MON", $sformatf("Observed READ:  Data = %0h", tx.data_out), UVM_MEDIUM)
    end
  endtask
endclass
