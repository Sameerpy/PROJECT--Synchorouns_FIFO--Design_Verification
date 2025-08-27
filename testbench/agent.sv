class fifo_agent extends uvm_agent;
  `uvm_component_utils(fifo_agent)

  fifo_driv driver;
  fifo_sqr  seqr;
  fifo_mon  monitor;

  function new(string name = "fifo_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    driver  = fifo_driv::type_id::create("driver", this);
    seqr    = fifo_sqr::type_id::create("seqr", this);
    monitor = fifo_mon::type_id::create("monitor", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    driver.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass
