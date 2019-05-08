## Project Zipline

## Introduction

Project Zipline is a program to accelerate innovation in lossless compression.  With this release Microsoft is making available:

* A new compression format called XP10 which is tailored for modern cloud datasets.
* All specifications for the entire pipeline.
* All RTL to support implementation for the entire pipeline.
* A testbench environment specifically developed for the VCS simulator.

Project Zipline is open-sourced under the MIT License, see the LICENSE file.

## Specifications
The following Project Zipline specifications have been included under the “specs” directory in this repository:

* Project_Zipline_Compression_Specification
* Project_Zipline_Huffman_Encoder_Micro_Architecture_Specification
* Project_Zipline_Comp_lz77_Micro_Architecture_Specification
* Project_Zipline_Crypto_Engine_Micro_Architecture_Specification
* Project_Zipline_Decompression_Top_Micro_Architecture_Specification
* Project_Zipline_Keyblob_Micro_Architecture_Specification
* Project_Zipline_KME_Micro_Architecture_Specification
* Project_Zipline_Prefix_Attach_Micro_Architecture_Specification
* Project_Zipline_Prefix_Micro_Architecture_Specification
* Project_Zipline_SSB_Micro_Architecture_Specification
* Project_Zipline_Top_Micro_Architecture_Specification

## Simulation Notes

Edit the file **`./zipline.setup`** for VCS, SYNTH, and VERDI environment settings.

Then source the file as follows:

**`source zipline.setup`**

Go to either the CCE_64, CDD_64, or KME run directory:

**`cd dv/CCE_64/run`**

**`cd dv/CDD_64/run`**

**`cd dv/KME/run`**

To build the simv executable:

**`make build_simv`**

Example for simulating a test:

**`make run_simv TESTNAME=xp10`**

Example for simulating a test with waves (.vpd):

**`make run_simv TESTNAME=xp10 WAVES=1`**

Example for simulating a test with Verdi waves (.fsdb):

**`make run_simv TESTNAME=xp10 VERDI_WAVES=1`**

All of the tests for the CCE_64, CDD_64, and KME can be run via a regress
script in the associated "run" directory:

**`dv/CCE_64/run/regress`**

**`dv/CDD_64/run/regress`**

**`dv/KME/run/regress`**

All test files are located in the associated engine directory "tests".
Each directory also contains a README file with a description of each test.

**`dv/CCE_64/tests`**

**`dv/CDD_64/tests`**

**`dv/KME/tests`**

A description of the programmable registers in the CCE/CDD/KME can be found
in the register_doc directory. Please read register_doc/README for more details.

## KME Notes

The KME RTL (rtl/cr_kme) has been modified to remove the following modules:
* AES engine in the random GUID generator
* SHA engines within the KDF function
* AES engine within the Key Decryption logic

With these reductions, the RTL only supports Key Types 1-6 without KDF and 
Key Type 0 without encryption/authentication
 
Additionally, the KME output has been reduced to support a single engine.
 
All modifications are identified with "KME_MODIFICATION_NOTE" comments
in the RTL code.

## Synthesis Notes

Note: For synthesis, please edit syn/Makefile to choose an LSF or dedicated
machine with at least 16G of memory.  Edit the contents of this line,
before "dc_shell":

**`bsub -Is -q irv-cpx-M16 -R "rusage [mem=16000]" dc_shell -f syn_example.tcl | tee ./LOGS/syn_eample.tcl.`date '+%m%d.%H:%M'`.log`**

To run synthesis for CDD

**`cd syn/cr_cddip`**

**`make syn`**

To run synthesis for CCE

**`cd syn/cr_cceip_64`**

**`make syn`**

To run synthesis for KME

**`cd syn/cr_kme`**

**`make syn`**
