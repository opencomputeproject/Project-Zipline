## Project Zipline

## Introduction

Project Zipline is a program to accelerate innovation in lossless compression.  With this release Microsoft is making two contributions to the OCP open source community:

1.	A new compression format called XP10 which is tailored for modern cloud datasets.

2.	An RTL implementation which accelerates Huffman Encoding for XP10, Zlib and Gzip.

Future releases will include additional RTL, an RTL test harness and an XP10 SW library.

Project Zipline is open-sourced under the MIT License, see the LICENSE file.

## Build instructions

Instructions for building the RTL design of the Project Zipline / XP10 Huffman Encoder.

Edit the file **./build.setup** for VCS environment settings

Then source the file as follows:

**`source build.setup`**

Go to the huff run directory:

**`cd dv/huff/run`**

Compile the RTL into a simv executable:

**`make compile_rtl`**
  
Note: There is no testbench included as part of this release



