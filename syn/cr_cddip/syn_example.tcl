# *************************************************************************
#
# Copyright © Microsoft Corporation. All rights reserved.
# Copyright © Broadcom Inc. All rights reserved.
# Licensed under the MIT License.
#
# *************************************************************************
analyze -f sverilog -vcs "-f cr_cddip.vlist"
elaborate cr_cddip

write -format ddc     -h -o     cr_cddip.ddc


exit
