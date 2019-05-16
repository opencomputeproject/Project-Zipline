## Project Zipline - FAQ
    
#### What is the quickest way to ramp on Project Zipline and the XP10 compression algorithm?
    Please see .\Project_Zipine_Overview.pptx.

#### Does the implementation only support the XP10 compression algorithm?
    The implementation supports XP10, Zlib, and Gzip. 

#### I only see RTL code for the XP10 compressor.  Is there a plan to Open Source the XP10 decompressor as well?
    During OCP Summit'19, only the Huffman encoder associated with compression was released.
    As Microsoft announced during the opening keynote, we will be open sourcing the entire
    compression and decompression pipelines.  This will include hooks for data authentication
    and encryption as well.  We will also release a test bench to allow developers to exercise
    the pipeline implementation.  Please see HISTORY.md or individual component release history.
    
#### How does XP10 differ from other compression implementations, specifically Zlib and Gzip?
    All three standards are based on the use of LZ77 and Huffman tables.  XP10 differs from
    Zlib and Gzip in the following important ways:
        * Supports larger search windows 
        * Uses a different symbol alphabet
        * Minimized headers optimized for small buffers

#### What is the compression ratio for XP10?
    There are a number of difficulties that arise attepmting to compare the XP10
    compression ratios with compression ratios from other efforts.  There are several
    methods which have been used to combine the separate buffers within a single corpus
    (combining all the buffers, decomposing buffers into smaller partitions, summing
    buffers using a geometric mean vs. average CR).  Microsoft contends that a geometric
    mean of the compression ratios is what makes the most sense, and thus we've used that
    approach internally.

#### Why is XP10 a better compression solution than Zlib and Gzip?
    The compression ratio depends on the data being compressed, the compression algorithm,
    and the format defined by the compression standard.  Whether XP10 or Zlib will produce
    a smaller compressed data buffer will depend on these factors.  In general, Microsoft
    has observed gains in compression ratio when handling modern cloud datasets.
    
    For the released XP10 RTL implementation, Microsoft has observed the following::
        * For the standard corpuses, XP10 provides a slightly better compression ratio than
          Zlib Level 9.
        * For Microsoft's internal cloud datasets, the XP10 typically provides a 5% - 10%
          better compression ratio than Zlib Level 9;  however, Microsoft has a corpus
          where we've observed an XP10 compression ratio approximately 40% better than
          Zlib Level 9.
          
#### It appears the XP10 specification closely parallels GZip (LZ77 + Huffman) with only a different file format.  What makes XP10 different from Gzip and why is it better?
    In some respects, XP10 is similar to both Gzip and Zlib.  And the RTL also supports
    both of those compression specifications.  However, there are two advantages
    observed with XP10:
        1. Cloud datasets:  Given the results from the cloud datasets and the sensitivity of
           the information we faced a dilemma.  We could release some information on how XP10
           produces better compression ratios but we cannot share the datasets.  Alternatively,
           we could not share any information.  We chose the former.  We are hoping to find
           IOT/cloud customers who are willing to share some datasets.
        2. Backward Compatibility:  The XP10 compression is an improvement over XP9, a
           compression algorithm developed and used internally at Microsoft.  Microsoft has
           generated a large amount of data in the XP9 format.  Thus, backward compatibility
           only affects Microsoft. 
      
#### Are benchmark results available?
    Currently there is no benchmarking data available.  Microsoft has found that a geometric
    mean is the most appropriate method for rolling up compression results.  This is a
    method not widely used so comparisons with other results are often not meaningful.
     
#### Is the implementation tailored for an ASIC or an FPGA?
    The RTL is really a starting point.  The target technology could be an FPGA or an ASIC.
    Which is more appropriate would depend on the goals for that implementation.  The RTL
    can be modified to shift the design point.
         
#### There are defines in the RTL which reference FPGA_MOD.  What is that used for?
    During development an FPGA prototyping system was used.  FPGA_MOD was used to simplify
    the RTL to ease the mapping to an FPGA prototyping system which used older FPGAs.  This
    define is not related to whether the final implementation is in an ASIC or FPGA.
