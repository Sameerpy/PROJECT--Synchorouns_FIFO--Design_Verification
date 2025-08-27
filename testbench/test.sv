class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

  fifo_env env;
  base_seq seq;  

  function new(string name = "fifo_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = fifo_env::type_id::create("env", this);
    seq = base_seq::type_id::create("seq");

  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("FIFO_TEST", "Starting the base sequence", UVM_LOW)

    seq.start(env.agent.seqr);  

    `uvm_info("FIFO_TEST", "Sequence completed successfully", UVM_LOW)
    phase.drop_objection(this);
  endtask

endclass
