## Project Zipline

## Introduction

Project Zipline is a program to accelerate innovation in lossless compression.  With this release Microsoft is making two contributions to the OCP open source community:

* A new compression format called XP10 which is tailored for modern cloud datasets.
* An RTL implementation which accelerates Huffman Encoding for XP10, Zlib and Gzip.

Future releases will include additional RTL, an RTL test harness and an XP10 SW library.

Project Zipline is open-sourced under the MIT License, see the LICENSE file.

## Specifications
The following Project Zipline specifications have been included under the “specs” directory in this repo.

* Project_XP10_Compression_Specification
* Project_Zipline_Huffman_Encoder_Micro_Architecture_Specification

## Build instructions

Instructions for building the RTL design of the Project Zipline Huffman Encoder.

Edit the file **./build.setup** for VCS environment settings

Then source the file as follows:

**`source build.setup`**

Go to the huff run directory:

**`cd dv/huff/run`**

Compile the RTL into a simv executable:

**`make compile_rtl`**
  
Notes:
1. RTL developed and simulated using Synopsys® VCS-MX 2017.03-SP1 toolchain.
2. No testbench is included for this release.
