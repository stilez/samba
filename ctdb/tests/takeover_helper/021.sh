#!/bin/sh

. "${TEST_SCRIPTS_DIR}/unit.sh"

define_test "3 nodes, all healthy, IPs all assigned"

setup_ctdbd <<EOF
NODEMAP
0       192.168.20.41   0x0     CURRENT RECMASTER
1       192.168.20.42   0x0
2       192.168.20.43   0x0

IFACES
:Name:LinkStatus:References:
:eth2:1:2:
:eth1:1:4:

PUBLICIPS
10.0.0.31  0
10.0.0.32  1
10.0.0.33  2
10.0.0.34  -1
EOF

ctdb_cmd setvar NoIPTakeover 1

ok <<EOF
Failed to find node to cover ip 10.0.0.34
EOF
test_takeover_helper

required_result 0 <<EOF
Public IPs on ALL nodes
10.0.0.31 0
10.0.0.32 1
10.0.0.33 2
10.0.0.34 -1
EOF
test_ctdb_ip_all
