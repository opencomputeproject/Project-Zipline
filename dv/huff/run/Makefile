# *************************************************************************
#
# Copyright © Microsoft Corporation. All rights reserved.
# Copyright © Broadcom Inc. All rights reserved.
# Licensed under the MIT License.
#
# *************************************************************************

export RTL_ROOT := ${PWD}/../../../rtl


COMMON_VCS_OPTS = +vcs+lic+wait -timescale=1ns/1ps -full64 -xlrm uniq_prior_final +lint=TFIPC-L
OTHER_VCS_OPTS = -Mupdate -picarchive -error=SDFCOM_CNOF,SDFPE +plusarg_save -assert svaext



compile_rtl: huff.vlist
	vlogan -work LIB_TOP $(COMMON_VCS_OPTS) +v2k -sverilog -assert svaext -Xrawtokens -f huff.vlist -l vlogan.log
	vcs cr_huf_comp $(COMMON_VCS_OPTS) -l vcs.log -o simv ${OTHER_VCS_OPTS} +notimingcheck +error+10 -debug_access+all



clean:
	-/bin/rm -rf simv 
	-/bin/rm -rf csrc
	-/bin/rm -r simv.daidir
	-/bin/rm -rf *.vdb
	-/bin/rm -rf *.log
	-/bin/rm -rf ucli.key vc_hdrs.h rawtokens*
	-/bin/rm -rf LIB_* 64
