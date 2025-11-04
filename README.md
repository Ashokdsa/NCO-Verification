# NCO-Verification

## Overview
UVM Testbench for Verification of a Numerically Controlled Oscillator(NCO) which can output 8 different types of waveform, digitally.(`Sine`, `Cosine`, `Triangular`, `Sinc`, `Sawtooth`, `Square`,`Gaussian Chirplet`,`ECG`).
\
The verification environment includes UVM components such as environment, driver, monitor, scoreboard, and test sequences. A Makefile is provided to compile, simulate, and clean the verification runs.

## Testbench Components
- **`nco_top.sv`**: Instantiates DUT and ties together the testbench.
- **`nco_test.sv`**: Instantiates and initializes the testbench components.
- **`nco_environment.sv`**: UVM environment coordinating verification agents.
- **`nco_driver.sv`**: Stimulus driver for DUT interface.
- **`nco_sequencer.sv`**: Contains a FIFO and handles the syncronization between `nco_driver` and `nco_sequence`.
- **`nco_active_monitor.sv`**: Used to capture transactions.
- **`nco_passive_monitor.sv`**: Observes DUT signals.
- **`nco_active_agent.sv`**: Instantiates `nco_driver`, `nco_sequencer` and `nco_active_monitor`, and connects `nco_sequencer` and `nco_driver`.
- **`nco_passive_agent.sv`**: Instantiates the `nco_passive_monitor`.
- **`nco_scoreboard.sv`**: Checks correctness against expected behavior.
- **`nco_sequence.sv`**: Test scenarios driving the driver.
- **`nco_sequence_item.sv`**: Used to communicate between the testbench components.
- **`nco_interface.sv`**: Bundles together a set of signals and associated behaviors to simplify the connection and communication between modules.

## Repository Structure
├── docs # Test Plans and documentation \
├── src # Testbench source files (UVM components) \
│   ├── define.svh  \
│   ├── Design  \
│   │   ├── nco.v # Design file \
│   ├── makefile \
│   ├── nco_active_agent.sv  \
│   ├── nco_passive_monitor.sv  \
│   ├── nco_subscriber.sv \
│   ├── nco_active_monitor.sv  \
│   ├── nco_pkg.svh             
│   ├── nco_test.sv \
│   ├── nco_driver.sv        
│   ├── nco_scoreboard.sv       
│   ├── nco_top.sv \
│   ├── nco_environment.sv    
│   ├── nco_sequence.sv         
│   ├── nco_interface.sv       
│   ├── nco_sequence_item.sv \
│   ├── nco_passive_agent.sv  \
│   └── nco_sequencer.sv \
└── README.md # Current File

## Running the Testbench
### Pre-Requisites
A **SystemVerilog simulator** that supports **UVM**, such as **QuestaSim**, **Cadence Xcelium**, or **Synopsys VCS**. \
\
*The makefile present in the **src/** contains only the execution commands for QuestaSim*

## Makefile Usage
The **Makefile** automates the compilation, and simulation of the **UVM** testbench. Which can be accessed only in the **src/** folder
1. To run the simulation with **UVM_MEDIUM** Verbosity and test **nco_regression_test**.
  ```
  make
  ```
\
2. To run the simulation with **SPECIFIC** Verbosity, with **other test cases**.
  ```
  make TEST=<test_name> V=<required_verbosity>
  ```
  Example:
  `make TEST=nco_normal_test V=UVM_MEDIUM` \
  \
3. To **clean up** log files, waveforms and cover report generated
  ```
  make clean
  ```
\
To simulate it **manually**
  ```
  source <Questa_location>
  vlog -sv +acc +cover +fcover -l nco.log nco_top.sv
  vsim -novopt work.nco_top
  ```
\
_Modify the Makefile as necessary for your simulator setup._
