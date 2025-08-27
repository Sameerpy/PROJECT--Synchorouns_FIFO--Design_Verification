module FIFO (
  output logic [7:0] data_out,
  output logic       full,
  output logic       empty,
  input  logic [7:0] data_in,
  input  logic       clock, reset, wn, rn
);

  logic [3:0] wptr, rptr;
  logic [7:0] memory [0:7];

  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      wptr     <= 0;
      rptr     <= 0;
     // data_out <= 0;
      for (int i = 0; i < 8; i++) memory[i] <= 0;
    end
    else begin
      if (wn && !full) begin
        memory[wptr[2:0]] <= data_in;
        wptr <= wptr + 1;
      end
      if (rn && !empty) begin
        data_out <= memory[rptr[2:0]];
        rptr <= rptr + 1;
      end
      if (wn && !full && rn && !empty) begin
   		wptr <= wptr + 1;
   		rptr  <= rptr + 1;
      end
    end
  end

  assign empty = (wptr == rptr);
  assign full  = (wptr[2:0] == rptr[2:0]) && (wptr[3] != rptr[3]);

endmodule
