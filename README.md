# Dual-Address-Pipelined-ROM-with-Dual-Port-Arbitration-in-Verilog

Designed a dual‑port, dual‑address ROM subsystem in Verilog with pipelined outputs and arbitration logic to support high‑speed, concurrent memory reads on two independent address ports.

Implemented synchronous ROM using hex file initialization and parameterizable address/data widths (6‑bit address, 8‑bit data) to allow reuse across different configurations.

Added registered pipeline stages on address and data paths to model realistic timing and reduce critical‑path delay, introducing controlled 2‑cycle read latency.

Developed a self‑checking verilog testbench with clock/reset generation and directed address patterns (same‑address, consecutive, and forward/backward access) to verify dual‑port and collision behavior.

Debugged ROM initialization and waveform timing in industry‑grade simulators using Xilix Vivado, validating correct data readout from the .memh file and arbitration outputs.
