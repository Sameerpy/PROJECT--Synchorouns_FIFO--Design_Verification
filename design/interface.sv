interface fifo_if(input logic clock, input logic reset);

  logic        wn;       
  logic        rn;       
  logic [7:0]  data_in;   
  logic [7:0]  data_out;  
  logic        full;      
  logic        empty;     

endinterface
