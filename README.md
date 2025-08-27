# FIFO Verification Project (UVM-Based)

This project implements a comprehensive UVM testbench to verify a parameterized synchronous FIFO design in SystemVerilog. The FIFO supports configurable depth and width, and handles simultaneous read/write operations when not full or empty. FIFO blocks are critical for buffering and data flow control in SoCs, and this verification effort ensures robust, cycle-accurate behavior.

## 🔍 Design Under Test (DUT)

- **Type**: Synchronous FIFO
- **Features**: Parameterized depth/width, simultaneous read/write, latency-aware readout
- **Behavior**: First-In-First-Out ordering, no overflow/underflow under valid conditions

## 🧪 UVM Testbench Architecture

- **Driver**: Drives read/write transactions from sequence items
- **Monitor**: Observes DUT interfaces and reports transactions
- **Scoreboard**: Compares expected vs. actual data for correctness and ordering
- **Sequencer & Sequences**: Generates directed and randomized traffic, including corner and stress scenarios
- **Subscriber**: Captures functional coverage metrics to assess verification completeness

## ✅ Verification Goals

- Correct handling of write, read, and simultaneous operations
- Accurate response to full and empty conditions
- Preservation of data integrity and FIFO ordering
- Latency modeling for synchronous reads (data appears on next cycle)
- Coverage-driven validation of corner cases and edge behaviors

---

This project demonstrates a modular, reusable UVM environment tailored for FIFO verification, with emphasis on clarity, correctness, and coverage. Ideal for learning, benchmarking, or extending to more complex memory subsystems.
