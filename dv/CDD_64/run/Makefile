
# *************************************************************************
#
# Copyright © Microsoft Corporation. All rights reserved.
# Copyright © Broadcom Inc. All rights reserved.
# Licensed under the MIT License..
#
# *************************************************************************

export RTL_ROOT := ${PWD}/../../../rtl
export DV_ROOT := ${PWD}/../../../dv

 
TESTNAME=xyz
SEED=1

COMMON_VCS_OPTS = +vcs+lic+wait -timescale=1ns/1ps -full64 -xlrm uniq_prior_final +lint=TFIPC-L
OTHER_VCS_OPTS = -Mupdate -picarchive -error=SDFCOM_CNOF,SDFPE +plusarg_save -assert svaext

ifeq ($(WAVES),1)
WAVES_PLUS = +waves+
else

ifeq ($(VERDI_WAVES),1)
WAVES_PLUS = +waves+ +dump_fsdb+
else
WAVES_PLUS =
endif

endif


ENV_PLUSARGS = +vpdfile+$(SEED).${TESTNAME}.vpd +fsdbfile+$(SEED).${TESTNAME}.fsdb $(WAVES_PLUS) +info_off

.PHONY : simv


build_simv: zipline.vlist
	vlogan -work LIB_TOP $(COMMON_VCS_OPTS) +v2k -sverilog -assert svaext -Xrawtokens -f zipline.vlist -l vlogan.log
	vcs zipline_tb $(COMMON_VCS_OPTS) -l vcs.log -o simv ${OTHER_VCS_OPTS} +notimingcheck -debug_all +error+10 -debug_access+all 


run_simv:
ifeq ($(shell test -e simv && echo -n yes),yes)
	simv -assert nopostproc $(ENV_PLUSARGS) +TESTNAME=${TESTNAME} +SEED=${SEED} | tee $(SEED).${TESTNAME}_sv.log 
else
	echo !!!WARNING!!!  Must build simv first
endif


clean:
	-/bin/rm -r simv 
	-/bin/rm -r csrc
	-/bin/rm -r simv.daidir
	-/bin/rm -r *.log
	-/bin/rm -r *.vdb
	-/bin/rm -r ucli.key vc_hdrs.h rawtokens*
	-/bin/rm -r LIB_* 64
