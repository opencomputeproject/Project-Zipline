# *************************************************************************
#
# Copyright © Microsoft Corporation. All rights reserved.
# Copyright © Broadcom Inc. All rights reserved.
# Licensed under the MIT License.
#
# *************************************************************************

analyze -f sverilog -vcs "-f cr_kme.vlist"
elaborate cr_kme

write -format ddc     -h -o     cr_kme.ddc


exit
