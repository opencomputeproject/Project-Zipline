##########################################################################
#
# Copyright © Microsoft Corporation. All rights reserved.
# Copyright © Broadcom Inc. All rights reserved.
# Licensed under the MIT License.
#
# 
##########################################################################

# MAKE VARIABLES
SHELL = /bin/csh
DEBUG = 0
FN = (Makefile):


# DEFAULT TARGET
.DEFAULT_GOAL = syn



clean: 
	@-rm -rf ./LOGS
	@-rm -rf ./WORK
	@-rm syn

# Replace the "bsub" command for one that works in your system
syn:    
	@if !(-d ./LOGS)    /bin/mkdir ./LOGS
	@if !(-d ./WORK)    /bin/mkdir ./WORK
	bsub -Is -q irv-cpx-M16 -R "rusage [mem=16000]" dc_shell -f syn_example.tcl | tee ./LOGS/syn_eample.tcl.`date '+%m%d.%H:%M'`.log
	@-rm -f command.log filenames.log
	@-mv *.mr  ./WORK/.
	@-mv *.pvl ./WORK/.
	@-mv *.syn ./WORK/.
	@-mv *.pvk ./WORK/.

	@echo "** LOGS$(FN) COMPLETED TARGET: $@"
	@echo "**"
	@touch $@




help: _help

