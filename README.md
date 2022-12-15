# Design-and-implementation-of-memory-BIST-on-an-FPGA
Implemented Memory Built in self test (MBIST) in an FPGA.The design consists of a custom memory block and BIST controller which implements march-c algorithm to detect various faults.

## Language
Verilog

## Tool used
Xilinx Vivado

## Hardware device
VC707 Evaluation Board

## Project Structure:

```
.
├── DFT_Report.pdf                       # Detailed report of project
├── MBistController.v                    # Design files - Top module
├── MBistController_TB.v                 # Test Bench
├── MBistController_TB_behav.wcfg        # Waveform Configuration file
├── MBistController_TB_behav.wdb         # Waveform Database File
├── ram.v                                # Design file - RAM module
└── README.md
```

## Steps to Run project:
- Open Vivado GUI.
- In the TCL console, type: cd {to the path where .wdb & .wcg is present}
Run the following:

```
current_fileset
open_wave_database xxxx.wdb
open_wave_config xxxx.wcfg
```

## About Project:
To test semiconductor memories, one of the most widely used techniques is MBIST (Memory Built-in Self-Test). We are using March algorithms since March based tests are simple and possess good fault coverage. The primary purpose of this project is to implement MBIST using the MARCH algorithm on an 8x8 memory cell and detect stuck-at faults, transition faults & coupling faults.
<br>
There are many DFT techniques used to test the memories. But each method has its pros & cons. 
As embedded memories are dense and compact, BIST has been proven to be one of the most cost-effective and widely used solutions as:
1) No external test equipment; 
2) Reduced development efforts.
3) Tests can run at circuit speed to yield a more realistic test time.

Memories are tested with special algorithms which detect the faults occurring in memories. Several different algorithms can be used to test RAMs and ROMs like:
• 0/1 algorithm
• Checker-board algorithm
• MARCH algorithm etc.

MARCH ALGORITHM:
A March test consists of a finite sequence of March elements. A March element is a finite sequence of operations applied to every cell in the memory array before proceeding to the next cell. An operation can consist of writing a 0 into a cell (w0), writing a one into a cell (w1), reading an expected 0 from a cell (r0), and reading an expected one from a cell (r1).

March X Algorithm:
Step1: write 0 with Increasing addressing order
Step2: read 0 and write 1 with Increasing addressing order
Step3: read 1 and write 0 with Decreasing addressing order
Step4: read 0 with Decreasing addressing order

<br>
Note: Detailed explanation present in DTF_Report.pdf


### MBIST Architecture
<p align="center">
<img src="https://user-images.githubusercontent.com/69337981/207967761-5928ed76-ca54-49dc-98e5-73f457d6d67f.png" width="500" height="400"> 
</p>

## Simulation Results
### Fault free
<img src="https://user-images.githubusercontent.com/69337981/207963773-34212a11-5e0e-42d6-b190-6465fcc62ea8.png" width="500" height="400" align="center"> 

### Stuck at faults
<img src="https://user-images.githubusercontent.com/69337981/207963818-f947c1a2-cd95-44bd-8401-25082d5e9519.png" width="500" height="300"> <img src="https://user-images.githubusercontent.com/69337981/207963866-332ffbb0-1e5a-485d-ae15-3639437da9c1.png" width="500" height="300">

### Transition faults
<img src="https://user-images.githubusercontent.com/69337981/207963889-37f69af8-6afd-4914-b726-d78534bf6a43.png" width="500" height="300"> <img src="https://user-images.githubusercontent.com/69337981/207963912-47a16956-9c63-40b5-83b3-d7341a21beac.png" width="500" height="300">

### Coupling Faults
<img src="https://user-images.githubusercontent.com/69337981/207963955-90e9ac2d-f6fb-4a0e-901a-004d0cd2dcd3.png" width="500" height="400">

## Conclusion:
We have successfully implemented the MBIST using March March X algorithm and tested its functionality by adding a few faults into the memory and detecting it. We have inserted the following faults and successfully detected them.
<img src="https://user-images.githubusercontent.com/69337981/207969176-7e27f396-a230-4ea8-9cfb-195bfc3cb1d8.png" width="400" height="300"> 

