class fifo_sqr extends uvm_sequencer#(fifo_trans);
  `uvm_component_utils(fifo_sqr) 

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
