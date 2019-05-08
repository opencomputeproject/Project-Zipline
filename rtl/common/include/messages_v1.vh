/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/








































































`ifdef DC
 `ifdef DISABLE_MESSAGE_COORDINATOR
 `else
  `define DISABLE_MESSAGE_COORDINATOR
 `endif
`endif

`ifdef DISABLE_MESSAGE_COORDINATOR
  `define FATAL  $display
  `define ERROR  $display
  `define DEBUG  $display
  `define INFO   $display
  `define STATUS $display
  `define WARN   $display
`else

 `ifdef MC
 `else
  `define MC message_coordinator
 `endif

 `ifdef NS
 `else
  `define NS * 1
 `endif

 `ifdef FATAL
 `else
  `define FATAL if(`MC.fatal_flag); else if(!(`MC.fatal(1,i_am))); else $display
 `endif

 `ifdef ERROR
 `else
  `define ERROR if (!(`MC.error(`MC.error_limit, i_am))); else $display
 `endif

 `ifdef DEBUG
 `else
  `define DEBUG if (!(`MC.debug(`MC.debug_on, i_am))); else $display
 `endif

 `ifdef INFO
 `else
  `define INFO if (!(`MC.info(`MC.info_on, i_am))); else $display
 `endif

 `ifdef STATUS
 `else
  `define STATUS if (!(`MC.status(1))); else $display
 `endif

 `ifdef WARN
 `else
  `define WARN if (!(`MC.warn(`MC.warn_on, i_am))); else $display
 `endif

 `ifdef ENTER
 `else
  `define ENTER $display($time/(1 `NS),, "STATUS: Entering %m")
 `endif

 `ifdef LEAVE
 `else
  `define LEAVE $display($time/(1 `NS),, "STATUS: Exiting %m")
 `endif

 `ifdef SUMMARY
 `else
  `define SUMMARY `MC.summary; $display($time/(1 `NS),, "STATUS: Exiting"); $finish(2)
 `endif

 `ifdef ENABLE_MESSAGES
 `else
  `define ENABLE_MESSAGES parameter [256*8:0] i_am = 
 `endif

 `ifdef MESSAGE_COORDINATOR
 `else
  `define MESSAGE_COORDINATOR



module message_coordinator ();

   event error_stop_ev;
   event error_no_stop_ev;
   event debug_ev;
   event info_ev;
   event warn_ev;

   reg   error_flag;
   reg   fatal_flag;

   reg [31:0] error_limit;
   reg [31:0] error_count;

   reg [31:0] warn_count;
   
   reg   debug_on;   
   reg   info_on;   
   reg   warn_on;   

   reg [31:0] timeout;
   
   initial
      begin
         error_flag    = 0;
         fatal_flag    = 0;
         error_count   = 0;
         warn_count    = 0;
`ifdef CARBON_VERILOG_2001
        `ifdef debug_on
          debug_on = 1; 
        `endif
        `ifdef info_on 
          info_on = 1;
        `endif
        `ifdef warn_on
          warn_on = 1;
        `endif
        `ifdef error_limit
          error_limit = 1; 
        `endif
        `ifdef timeout
          timeout = 1;
        `endif
`else
         debug_on      = $test$plusargs("debug_on");
         info_on       = !$test$plusargs("info_off");
         warn_on       = !$test$plusargs("warn_off");
         if (!$value$plusargs("error_limit=%d", error_limit))
            error_limit = 0;
         if (!$value$plusargs("timeout=%d", timeout))
            timeout = 0;
`endif
      end 

   function fatal;
     input dummy;
     input [1023:0] i_am;
     begin
        error_count = error_count + 1;
        $write ($time/(1 `NS),, "FATAL(%0s): ", i_am);
        fatal = 1;
        error_flag = 1;
        fatal_flag = 1;
        -> error_stop_ev;
     end
   endfunction 

   function error;
     input [31:0] error_limit;
     input [1023:0] i_am;
     begin
        error_count = error_count + 1;
        $write ($time/(1 `NS),, "ERROR(%0s): ", i_am);
        if (error_limit)
           begin
              if (error_count == error_limit)
                 -> error_stop_ev;
              else
                 -> error_no_stop_ev;
           end
        else
           -> error_no_stop_ev;
        error = 1;
        error_flag = 1;
     end
   endfunction 

   function debug;
     input debug_flag;
     input [1023:0] i_am;
     begin
        if (debug_flag)
           begin
              $write ($time/(1 `NS),, "DEBUG(%0s): ", i_am);
           end
        -> debug_ev;
        debug = debug_flag;
     end
   endfunction 

   function info;
     input info_flag;
     input [1023:0] i_am;
     begin
        if (info_flag)
           begin
              $write ($time/(1 `NS),, "INFO(%0s): ", i_am);
           end
        -> info_ev;
        info = info_flag;
     end
   endfunction 

   function status;
     input dummy;
     begin
        $write ($time/(1 `NS),, "STATUS: ");
        status = 1;
     end
   endfunction 

   function warn;
     input warn_flag;
     input [1023:0] i_am;
     begin
        warn_count = warn_count + 1;
        if (warn_flag)
           begin
              $write ($time/(1 `NS),, "WARN(%0s): ", i_am);
           end
        -> warn_ev;
        warn = warn_flag;
     end
   endfunction 
   
   task summary;
     begin
        if (error_count !== 1'b0)
           $display($time/(1 `NS),, 
                    "STATUS: Test Failed (%0d error%s, %0d warning%s)", 
                    error_count, (error_count==1)?"":"s",
                    warn_count,  (warn_count==1)?"":"s");
        else
           $display($time/(1 `NS),, 
                    "STATUS: Test Passed (%0d error%s, %0d warning%s)", 
                    error_count, (error_count==1)?"":"s",
                    warn_count,  (warn_count==1)?"":"s");
     end
   endtask 

   always @(error_stop_ev) 
      begin
         error_flag = 1'b1;
         #0;
         if (fatal_flag)
            $display($time/(1 `NS),, "STATUS: Fatal Error");
         else
            $display($time/(1 `NS),, "STATUS: Error Limit Exceeded");
         summary; 
         $display($time/(1 `NS),, "STATUS: Exiting");
         $finish(2);
      end 

   always @(error_no_stop_ev) 
      error_flag = 1'b1;

   initial
     begin : timeout_mechanism
        if (timeout)
           begin
              #(timeout);
              $display($time/(1 `NS),, 
                       "FATAL: Test timed out (detected in %m at %0dnS)", 
                       timeout);
              fatal_flag = 1;
              error_count = error_count + 1;
              -> error_stop_ev;
           end
     end 
   
endmodule 


 `endif

`endif 

