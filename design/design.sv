module FIFO #(
  parameter DATA_WIDTH = 8,
  parameter DEPTH      = 8,
  parameter ADDR_WIDTH = $clog2(DEPTH)
)(
  output logic [DATA_WIDTH-1:0] data_out,
  output logic                  full,
  output logic                  empty,
  input  logic [DATA_WIDTH-1:0] data_in,
  input  logic                  clock, reset, wn, rn
);

  logic [ADDR_WIDTH:0] wptr, rptr;   // Extra MSB for full detection
  logic [DATA_WIDTH-1:0] memory [0:DEPTH-1];

  // Sequential logic
  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      wptr     <= 0;
      rptr     <= 0;
      data_out <= '0;
      for (int i = 0; i < DEPTH; i++) memory[i] <= '0;
    end
    else begin
      // Simultaneous Read and Write (only when not full & not empty)
      if (wn && rn && !full && !empty) begin
        memory[wptr[ADDR_WIDTH-1:0]] <= data_in;  // write new data
        data_out <= memory[rptr[ADDR_WIDTH-1:0]]; // read old data
        wptr <= wptr + 1;
        rptr <= rptr + 1;
      end

      // Write only
      else if (wn && !full) begin
        memory[wptr[ADDR_WIDTH-1:0]] <= data_in;
        wptr <= wptr + 1;
      end

      // Read only
      else if (rn && !empty) begin
        data_out <= memory[rptr[ADDR_WIDTH-1:0]];
        rptr <= rptr + 1;
      end
    end
  end

  // Status flags
  assign empty = (wptr == rptr);
  assign full  = (wptr[ADDR_WIDTH-1:0] == rptr[ADDR_WIDTH-1:0]) &&
                 (wptr[ADDR_WIDTH] != rptr[ADDR_WIDTH]);

endmodule
