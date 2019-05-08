/*************************************************************************
*
* Copyright © Microsoft Corporation. All rights reserved.
* Copyright © Broadcom Inc. All rights reserved.
* Licensed under the MIT License.
*
*************************************************************************/
`include "cr_global_params.vh"

`define FSDB_PATH kme_tb

module kme_tb;   
   
   string testname;
   string seed;
   reg[31:0] initial_seed;
   int  error_cntr;

   string fsdbFilename;
  

   logic clk;
   logic rst_n;

   logic kme_ib_tready;
   logic [`AXI_S_TID_WIDTH-1:0]  kme_ib_tid;
   logic [`AXI_S_DP_DWIDTH-1:0]  kme_ib_tdata;
   logic [`AXI_S_TSTRB_WIDTH-1:0] kme_ib_tstrb;
   logic [`AXI_S_USER_WIDTH-1:0] kme_ib_tuser;
   logic                         kme_ib_tvalid;
   logic                         kme_ib_tlast;

   logic kme_ob_tready;
   logic [`AXI_S_TID_WIDTH-1:0]  kme_ob_tid;
   logic [`AXI_S_DP_DWIDTH-1:0]  kme_ob_tdata;
   logic [`AXI_S_TSTRB_WIDTH-1:0] kme_ob_tstrb;
   logic [`AXI_S_USER_WIDTH-1:0] kme_ob_tuser;
   logic                         kme_ob_tvalid;
   logic                         kme_ob_tlast;    

   logic [`N_RBUS_ADDR_BITS-1:0] kme_apb_paddr;
   logic                         kme_apb_psel;
   logic                         kme_apb_penable;
   logic                         kme_apb_pwrite;
   logic [`N_RBUS_DATA_BITS-1:0] kme_apb_pwdata;  
   logic [`N_RBUS_DATA_BITS-1:0] kme_apb_prdata;
   logic                         kme_apb_pready;		        
   logic                         kme_apb_pslverr;

   
   initial begin
      clk = 1'b0;
      forever
	begin
           #0.625;
           clk = ~clk;
	end
   end
   
   apb_xactor #(.ADDR_WIDTH(`N_RBUS_ADDR_BITS),.DATA_WIDTH(`N_RBUS_DATA_BITS)) apb_xactor(
											  .clk(clk), 
											  .reset_n(rst_n), 
											  .prdata(kme_apb_prdata), 
											  .pready(kme_apb_pready), 
											  .pslverr(kme_apb_pslverr), 
											  .psel(kme_apb_psel), 
											  .penable(kme_apb_penable), 
											  .paddr(kme_apb_paddr), 
											  .pwdata(kme_apb_pwdata), 
											  .pwrite(kme_apb_pwrite)
											  );
   
   cr_kme kme_dut(
		  .kme_ib_tready(kme_ib_tready), 
		  .kme_ib_tvalid(kme_ib_tvalid),
		  .kme_ib_tlast(kme_ib_tlast),
		  .kme_ib_tid(kme_ib_tid),
		  .kme_ib_tstrb(kme_ib_tstrb),
		  .kme_ib_tuser(kme_ib_tuser),
		  .kme_ib_tdata(kme_ib_tdata),

		  .kme_cceip0_ob_tready(kme_ob_tready), 
		  .kme_cceip0_ob_tvalid(kme_ob_tvalid),
		  .kme_cceip0_ob_tlast(kme_ob_tlast),
		  .kme_cceip0_ob_tid(kme_ob_tid),
		  .kme_cceip0_ob_tstrb(kme_ob_tstrb),
		  .kme_cceip0_ob_tuser(kme_ob_tuser),
		  .kme_cceip0_ob_tdata(kme_ob_tdata),
      
/* -----\/----- EXCLUDED -----\/-----
		  .kme_cceip1_ob_tready(), 
		  .kme_cceip1_ob_tvalid(),
		  .kme_cceip1_ob_tlast(),
		  .kme_cceip1_ob_tid(),
		  .kme_cceip1_ob_tstrb(),
		  .kme_cceip1_ob_tuser(),
		  .kme_cceip1_ob_tdata(),

		  .kme_cceip2_ob_tready(), 
		  .kme_cceip2_ob_tvalid(),
		  .kme_cceip2_ob_tlast(),
		  .kme_cceip2_ob_tid(),
		  .kme_cceip2_ob_tstrb(),
		  .kme_cceip2_ob_tuser(),
		  .kme_cceip2_ob_tdata(),

		  .kme_cceip3_ob_tready(), 
		  .kme_cceip3_ob_tvalid(),
		  .kme_cceip3_ob_tlast(),
		  .kme_cceip3_ob_tid(),
		  .kme_cceip3_ob_tstrb(),
		  .kme_cceip3_ob_tuser(),
		  .kme_cceip3_ob_tdata(),

		  .kme_cddip0_ob_tready(), 
		  .kme_cddip0_ob_tvalid(),
		  .kme_cddip0_ob_tlast(),
		  .kme_cddip0_ob_tid(),
		  .kme_cddip0_ob_tstrb(),
		  .kme_cddip0_ob_tuser(),
		  .kme_cddip0_ob_tdata(),
      
		  .kme_cddip1_ob_tready(), 
		  .kme_cddip1_ob_tvalid(),
		  .kme_cddip1_ob_tlast(),
		  .kme_cddip1_ob_tid(),
		  .kme_cddip1_ob_tstrb(),
		  .kme_cddip1_ob_tuser(),
		  .kme_cddip1_ob_tdata(),

		  .kme_cddip2_ob_tready(), 
		  .kme_cddip2_ob_tvalid(),
		  .kme_cddip2_ob_tlast(),
		  .kme_cddip2_ob_tid(),
		  .kme_cddip2_ob_tstrb(),
		  .kme_cddip2_ob_tuser(),
		  .kme_cddip2_ob_tdata(),

		  .kme_cddip3_ob_tready(), 
		  .kme_cddip3_ob_tvalid(),
		  .kme_cddip3_ob_tlast(),
		  .kme_cddip3_ob_tid(),
		  .kme_cddip3_ob_tstrb(),
		  .kme_cddip3_ob_tuser(),
		  .kme_cddip3_ob_tdata(),
 -----/\----- EXCLUDED -----/\----- */
      
		  .apb_paddr(kme_apb_paddr[`N_KME_RBUS_ADDR_BITS-1:0]),
		  .apb_psel(kme_apb_psel), 
		  .apb_penable(kme_apb_penable), 
		  .apb_pwrite(kme_apb_pwrite), 
		  .apb_pwdata(kme_apb_pwdata),
		  .apb_prdata(kme_apb_prdata),
		  .apb_pready(kme_apb_pready), 
		  .apb_pslverr(kme_apb_pslverr),

		  .clk(clk), 
		  .rst_n(rst_n), 
		  .scan_en(1'b0), 
		  .scan_mode(1'b0), 
		  .scan_rst_n(1'b0), 
    
		  .ovstb(1'b1), 
		  .lvm(1'b0),
		  .mlvm(1'b0),

		  .kme_interrupt(),
		  .disable_debug_cmd(1'b0),
                  .kme_idle(),
		  .disable_unencrypted_keys(1'b0)
		  );

   initial begin

      error_cntr = 0;

      rst_n = 1'b0; 
      
      if( $test$plusargs("SEED") ) begin
         $value$plusargs("SEED=%d", seed);
      end else begin
	 seed="1";	
      end
      
      if( $test$plusargs("TESTNAME") ) begin
         $value$plusargs("TESTNAME=%s", testname);
         $display("TESTNAME=%s SEED=%d", testname, seed);
      end else begin
	 testname="unknown";	
      end
      
      if ( $test$plusargs("waves") ) begin
         if( $test$plusargs("dump_fsdb") ) begin
            $value$plusargs("fsdbfile+%s", fsdbFilename);
            $fsdbDumpfile(fsdbFilename);
            $fsdbDumpvars(0, `FSDB_PATH);
            $fsdbDumpMDA(0, `FSDB_PATH);
            $fsdbDumpvars(0, "+all", `FSDB_PATH);
         end else begin
            $vcdpluson();
            $vcdplusmemon();
         end
      end

      $display("--- \"rst_n\" is being ASSERTED for 100ns ---");

      #100;

      kme_ib_tid <= 0;
      kme_ib_tvalid <= 0;
      kme_ib_tlast <= 0;
      kme_ib_tdata <= 0;
      kme_ib_tstrb <= 0;
      kme_ib_tuser <= 0;
      kme_ob_tready <= 1;

      #50;

      $display("--- \"rst_n\" has been DE-ASSERTED! ---");

      rst_n = 1'b1; 

      #100;

      @(posedge clk);

      do_kme_config();

      fork
         begin
            service_ib_interface();
         end
         begin
            service_ob_interface();
         end
      join


      if ( error_cntr ) begin
	 $display("\nTest %s FAILED!\n", testname);
      end else begin
	 $display("\nTest %s PASSED!\n", testname);
      end

      #10ns;
      $finish;
      
   end // initial

   task do_kme_config();
      reg[31:0]      address;
      reg [31:0]     data;
      reg [31:0]     returned_data;
      string         operation;
      string         file_name;
      string         vector;
      integer        str_get;
      integer        file_descriptor;
      reg            response;

      
      file_name = $psprintf("../tests/kme.config");
      file_descriptor = $fopen(file_name, "r");
      if ( file_descriptor == 0 ) begin
	 $display ("\nAPB_INFO:  @time:%-d File %s NOT found!\n", $time, file_name );
	 return;
      end else begin
	 $display ("APB_INFO:  @time:%-d Openned test file -->  %s", $time, file_name );
      end

      while( !$feof(file_descriptor) ) begin
	 if ( $fgets(vector,file_descriptor) ) begin
            $display ("APB_INFO:  @time:%-d vector --> %s", $time, vector );
            str_get = $sscanf(vector, "%s 0x%h 0x%h", operation, address, data);
	    //      $display ("APB_INFO:  @time:%-d parsed vector --> %s 0x%h 0x%h    %d", $time, operation, address, data, str_get ); 
            if ( str_get == 3 && (operation == "r" || operation == "R" || operation == "w" || operation == "W") ) begin
               if ( operation == "r" || operation == "R" ) begin
		  apb_xactor.read(address, returned_data, response);
		  if ( response !== 0 ) begin
		     $display ("\n\nAPB_FATAL:  @time:%-d   Slave ERROR and/or TIMEOUT on the READ operation to address 0x%h\n\n",
                               $time, address );
		     $finish;
		  end
		  if ( returned_data !== data ) begin
		     $display ("APB_ERROR:  @time:%-d   Data MISMATCH --> Actual: 0x%h  Expect: 0x%h", $time, returned_data, data ); 
		     ++error_cntr;
		     if ( error_cntr > 10 ) begin
			$finish;
		     end
		  end
               end else begin
		  apb_xactor.write(address, data, response);
		  if ( response !== 0 ) begin
		     $display ("\n\nAPB_FATAL:  @time:%-d   Slave ERROR and/or TIMEOUT on the WRITE operation to address 0x%h\n\n",
                               $time, address );
		     $finish;
		  end
               end
               @(posedge clk);
            end else if ( operation !== "#" ) begin
               $display ("APB_FATAL:  @time:%-d vector --> %s NOT valid!", $time, vector );
               $finish;
            end
	 end
      end

      @(posedge clk);

      $display ("APB_INFO:  @time:%-d Exiting APB engine config ...", $time );

   endtask // do_kme_config

   task service_ib_interface();
      reg[7:0]       tstrb;
      reg [63:0]     tdata;
      string         tuser_string;
      string         file_name;
      string         vector;
      integer        str_get;
      integer        file_descriptor; 
      logic 	     saw_mega;
      logic 	     saw_guid_tlv;
      logic 	     have_guid_tlv;
      integer 	     mega_tlv_word_count;
      
      

      file_name = $psprintf("../tests/%s.inbound", testname);
      file_descriptor = $fopen(file_name, "r");
      if ( file_descriptor == 0 ) begin
	 $display ("INBOUND_FATAL:  @time:%-d File %s NOT found!", $time, file_name );
	 $finish;
      end else begin
	 $display ("INBOUND_INFO:  @time:%-d Openned test file -->  %s", $time, file_name );
      end

      saw_mega = 0;
      saw_guid_tlv = 0;
      mega_tlv_word_count = 0;
      have_guid_tlv = 0;
      
      while( !$feof(file_descriptor) ) begin
	 if ( kme_ib_tready === 1'b1 ) begin
            kme_ib_tlast <= 1'b0;
            if ( $fgets(vector,file_descriptor) ) begin
               str_get = $sscanf(vector, "0x%h %s 0x%h", tdata, tuser_string, tstrb);
	       //        $display ("INBOUND_INFO:  @time:%-d parsed vector --> 0x%h %s 0x%h %d", $time, tdata, tuser_string, tstrb, str_get ); 
               if ( str_get >= 2 ) begin
		  $display ("INBOUND_INFO:  @time:%-d vector --> %s", $time, vector ); 
		  if ( str_get == 3 ) begin
		     if ( tuser_string == "SoT" && tdata[7:0] >= 8'd21 ) begin
			saw_mega = 1;
		     end 
		     else if(tdata[7:0] == 8'd10) begin
			saw_guid_tlv = 1;
		     end
		     if (saw_mega == 1 ) begin
			mega_tlv_word_count = mega_tlv_word_count + 1;
			if(mega_tlv_word_count == 2) begin
			   $display("mega tlv word #2: %x", tdata);
			   if(tdata[4] == 1) begin
			      have_guid_tlv = 1;
			   end
			end
		     end
		     if ( tuser_string == "EoT" && saw_mega == 1 ) begin
			if( have_guid_tlv == 0 ) begin
			   kme_ib_tlast <= 1'b1;
			end
			saw_mega = 0;
		     end
		     else if(tuser_string == "EoT" && saw_guid_tlv == 1) begin
			kme_ib_tlast <= 1'b1;
			saw_guid_tlv = 0;
		     end
		     kme_ib_tuser <= translate_tuser( tuser_string );
		  end else begin
		     kme_ib_tuser <= 8'h00;
		  end
		  kme_ib_tvalid <= 1'b1;
		  kme_ib_tdata <= tdata;
		  kme_ib_tstrb <= tstrb;
               end else begin
		  kme_ib_tvalid <= 1'b0;
               end
            end else begin
               kme_ib_tvalid <= 1'b0;
            end
	 end
	 @(posedge clk);
      end

      kme_ib_tvalid <= 1'b0;
      kme_ib_tlast <= 1'b0;

      @(posedge clk);

      $display ("INBOUND_INFO:  @time:%-d Exiting INBOUND thread...", $time );

   endtask // service_ib_interface




   task service_ob_interface();
      reg[7:0]       tstrb;
      reg [7:0]      tuser;
      reg [63:0]     tdata;
      reg            tlast;
      string         tuser_string;
      string         file_name;
      string         vector;
      integer        str_get;
      integer        file_descriptor; 
      logic          saw_cqe;
      logic          saw_stats;
      logic          ignore_compare_result;
      logic          got_next_line;
      integer        watchdog_timer; 
      integer        rc; 

      

      file_name = $psprintf("../tests/%s.outbound", testname);
      file_descriptor = $fopen(file_name, "r");
      if ( file_descriptor == 0 ) begin
	 $display ("OUTBOUND_FATAL:  @time:%-d File %s NOT found!", $time, file_name );
	 $finish;
      end else begin
	 $display ("OUTBOUND_INFO:  @time:%-d Openned test file -->  %s", $time, file_name );
      end

      saw_cqe = 0;
      saw_stats = 0;
      got_next_line = 0; 
      watchdog_timer = 0;
      while( !$feof(file_descriptor) ) begin
	 if ( kme_ob_tvalid === 1'b1 ) begin
            watchdog_timer = 0;
            tlast = 1'b0;
            ignore_compare_result = 0;
            if ( got_next_line == 1 || $fgets(vector,file_descriptor) ) begin
               got_next_line = 0;
               while ( vector[0] === "#" && !$feof(file_descriptor) ) begin
		  rc = $fgets(vector,file_descriptor);
               end
               $display ("OUTBOUND_INFO:  @time:%-d vector --> %s", $time, vector );
               str_get = $sscanf(vector, "0x%h %s 0x%h", tdata, tuser_string, tstrb);
	       //        $display ("OUTBOUND_INFO:  @time:%-d parsed vector --> 0x%h %s 0x%h %d", $time, tdata, tuser_string, tstrb, str_get ); 
               if ( str_get == 3 ) begin
		  tuser = translate_tuser( tuser_string );
		  if ( tuser_string == "SoT" && tdata[7:0] == 8'h09 ) begin
		     saw_cqe = 1;
		  end
		  if ( tuser_string == "EoT") begin
		     tlast = 1'b1;
		     saw_cqe = 0;
		     rc = $fgets(vector,file_descriptor);
		     got_next_line = 1;
		  end
		  if ( tuser_string == "SoT" && tdata[7:0] == 8'h08 ) begin
		     saw_stats = 1;
		  end
		  if ( tuser_string == "EoT" && saw_stats == 1 ) begin
		     ignore_compare_result = 1;
		     saw_stats = 0;
		  end
               end else begin
		  tuser = 8'h00;
               end
               if ( kme_ob_tdata !== tdata && ignore_compare_result == 0 ) begin
		  $display ("OUTBOUND_ERROR:  @time:%-d   kme_ob_tdata MISMATCH --> Actual: 0x%h  Expect: 0x%h", $time, kme_ob_tdata, tdata ); 
		  ++error_cntr;
               end
               if ( kme_ob_tuser !== tuser ) begin
		  $display ("OUTBOUND_ERROR:  @time:%-d   kme_ob_tuser MISMATCH --> Actual: 0x%h  Expect: 0x%h", $time, kme_ob_tuser, tuser ); 
		  ++error_cntr;
               end
               if ( kme_ob_tstrb !== tstrb ) begin
		  $display ("OUTBOUND_ERROR:  @time:%-d   kme_ob_tstrb MISMATCH --> Actual: 0x%h  Expect: 0x%h", $time, kme_ob_tstrb, tstrb ); 
		  ++error_cntr;
               end
               if ( kme_ob_tlast !== tlast ) begin
		  $display ("OUTBOUND_ERROR:  @time:%-d   kme_ob_tlast MISMATCH --> Actual: 0x%h  Expect: 0x%h", $time, kme_ob_tlast, tlast ); 
		  ++error_cntr;
               end
            end else begin
               ++error_cntr;
               $display ("\nOUTBOUND_FATAL:  @time:%-d  No corresponding expect vector!\n", $time ); 
               $finish;
            end
	 end else begin
            ++watchdog_timer;
            if ( watchdog_timer > 10000 ) begin
               ++error_cntr;
               $display ("\nOUTBOUND_ERROR:  @time:%-d  Watchdog timer EXPIRED!\n", $time ); 
               $finish;
            end
	 end
	 @(posedge clk);
      end


      @(posedge clk);

      $display ("OUTBOUND_INFO:  @time:%-d Exiting OUTBOUND thread...", $time );

   endtask // service_ob_interface
   
   function logic[7:0] translate_tuser (string tuser);
      if ( tuser == "SoT" ) begin
         return 8'h01;
      end else if ( tuser == "EoT" ) begin
         return 8'h02;
      end else begin
         return 8'h03;
      end
   endfunction : translate_tuser

   
endmodule : kme_tb
