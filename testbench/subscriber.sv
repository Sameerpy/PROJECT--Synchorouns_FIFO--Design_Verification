class fifo_subs extends uvm_subscriber #(fifo_trans);
  `uvm_component_utils(fifo_subs)

  fifo_trans item;

  covergroup cgp;
    option.per_instance = 1;
    cp_ops : coverpoint {item.wn, item.rn} {
      bins write_only = {2'b10};
      bins read_only  = {2'b01};
      bins both       = {2'b11};
      bins idle       = {2'b00};
    }
    cp_status : coverpoint {item.full, item.empty} {
      bins fifo_full  = {2'b10}; // full=1, empty=0
      bins fifo_empty = {2'b01}; // empty=1, full=0
      illegal_bins bad = {2'b11}; // should never happen
    }
    cross_ops_status : cross cp_ops, cp_status;
  endgroup

  function new(string name="fifo_subs", uvm_component parent=null);
    super.new(name, parent);
    cgp = new();
  endfunction

  // Auto-connected via monitor.ap.connect(this.analysis_export)
  function void write(fifo_trans t);
    item = t;      
    cgp.sample();   
  endfunction
  
  function void report_phase(uvm_phase phase);
  super.report_phase(phase);
    `uvm_info("COV_REPORT", $sformatf("FIFO Subscriber Coverage = %0.2f %%", cgp.get_coverage()), UVM_NONE)
endfunction

	
endclass
