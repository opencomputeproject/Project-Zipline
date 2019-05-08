# *************************************************************************
#
# Copyright © Microsoft Corporation. All rights reserved.
# Copyright © Broadcom Inc. All rights reserved.
# Licensed under the MIT License.
#
# *************************************************************************

analyze -f sverilog -vcs "-f cr_cceip_64.vlist"
elaborate cr_cceip_64

write -format ddc     -h -o     cr_cceip_64.ddc


exit
