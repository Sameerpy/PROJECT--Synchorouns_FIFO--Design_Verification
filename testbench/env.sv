class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)

  fifo_agent agent;
  fifo_score scoreboard;
  fifo_subs subscriber;

  function new(string name = "fifo_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent      = fifo_agent::type_id::create("agent", this);
    scoreboard = fifo_score::type_id::create("scoreboard", this);
    subscriber = fifo_subs::type_id::create("subscriber", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    agent.monitor.mon_analysis_port.connect(scoreboard.score_analysis_export);
    agent.monitor.mon_analysis_port.connect(subscriber.analysis_export);
  endfunction

endclass
