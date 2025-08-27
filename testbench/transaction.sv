class fifo_trans extends uvm_sequence_item;
  rand bit         wn;
  rand bit         rn;
  rand bit [7:0]   data_in;

       bit [7:0]   data_out;
       bit         full;
       bit         empty;

  `uvm_object_utils_begin(fifo_trans)
    `uvm_field_int(wn,        UVM_ALL_ON)
    `uvm_field_int(rn,        UVM_ALL_ON)
    `uvm_field_int(data_in,   UVM_ALL_ON)
    `uvm_field_int(data_out,  UVM_ALL_ON)
    `uvm_field_int(full,      UVM_ALL_ON)
    `uvm_field_int(empty,     UVM_ALL_ON)
  `uvm_object_utils_end
  
  //constraint c1 {wn!=rn;}
 // constraint c2 {wn==1;}
  //constraint c2 {wn dist {0:=4, 1:=5};}

  function new(string name = "fifo_trans");
    super.new(name);
  endfunction

endclass
