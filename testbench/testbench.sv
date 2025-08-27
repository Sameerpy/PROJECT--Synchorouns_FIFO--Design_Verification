`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "transaction.sv"
`include "base_sequence.sv"
`include "driver.sv"
`include "monitor.sv"
`include "sequencer.sv"
`include "scoreboard.sv"
`include "subscriber.sv"
`include "agent.sv"
`include "env.sv"
`include "test.sv"

module tb_top;

  // Clock and reset
  logic clock;
  logic reset;

  // Instantiate the interface
  fifo_if intf (.clock(clock),.reset(reset));

  // Clock generation
  initial  clock = 0;
  always   #5 clock = ~clock;

  // Reset generation
  initial begin
    reset = 1;
    #14;
    reset = 0;
  end

  // DUT instantiation
  FIFO dut (
    .clock    (intf.clock),
    .reset    (intf.reset),
    .wn       (intf.wn),
    .rn       (intf.rn),
    .data_in  (intf.data_in),
    .data_out (intf.data_out),
    .full     (intf.full),
    .empty    (intf.empty)
  );

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "*", "fifo_if", intf);
    run_test("fifo_test");
  end

  initial begin
    $dumpvars;
    $dumpfile("wavedump.vcd");
  end
endmodule
