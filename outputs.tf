output "tunnel1_address" {
  value = aws_vpn_connection.vyatta.tunnel1_address
}

output "tunnel2_address" {
  value = aws_vpn_connection.vyatta.tunnel2_address
}

output "vyatta_script" {
  value = <<-EOT
configure
set vpn ipsec ike-group ${var.vpn_ike_group_name} lifetime '28800'
set vpn ipsec ike-group ${var.vpn_ike_group_name} proposal 1 dh-group '2'
set vpn ipsec ike-group ${var.vpn_ike_group_name} proposal 1 encryption 'aes128'
set vpn ipsec ike-group ${var.vpn_ike_group_name} proposal 1 hash 'sha1'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel2_address} authentication mode 'pre-shared-secret'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel2_address} authentication pre-shared-secret '${aws_vpn_connection.vyatta.tunnel2_preshared_key}'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel2_address} description '${var.vpn_name} Tunnel 1'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel2_address} ike-group '${var.vpn_ike_group_name}'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel2_address} local-address '${var.vyatta_endpoint.public_ip_address}'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel2_address} vti bind 'vti${var.vpn_tunnel_1_interface_id}'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel2_address} vti esp-group '${var.vpn_esp_group_name}'
set vpn ipsec ipsec-interfaces interface '${var.vyatta_endpoint.interface}'
set vpn ipsec esp-group ${var.vpn_esp_group_name} compression 'disable'
set vpn ipsec esp-group ${var.vpn_esp_group_name} lifetime '3600'
set vpn ipsec esp-group ${var.vpn_esp_group_name} mode 'tunnel'
set vpn ipsec esp-group ${var.vpn_esp_group_name} pfs 'enable'
set vpn ipsec esp-group ${var.vpn_esp_group_name} proposal 1 encryption 'aes128'
set vpn ipsec esp-group ${var.vpn_esp_group_name} proposal 1 hash 'sha1'
set vpn ipsec ike-group ${var.vpn_esp_group_name} dead-peer-detection action 'restart'
set vpn ipsec ike-group ${var.vpn_esp_group_name} dead-peer-detection interval '15'
set vpn ipsec ike-group ${var.vpn_esp_group_name} dead-peer-detection timeout '30'
set interfaces vti vti${var.vpn_tunnel_1_interface_id} address '${aws_vpn_connection.vyatta.tunnel2_cgw_inside_address}/30'
set interfaces vti vti${var.vpn_tunnel_1_interface_id} description '${var.vpn_name} Tunnel 1'
set interfaces vti vti${var.vpn_tunnel_1_interface_id} mtu '1436'
set protocols bgp ${var.aws_endpoint.bgp_asn} neighbor ${aws_vpn_connection.vyatta.tunnel2_vgw_inside_address} remote-as '${aws_vpn_connection.vyatta.tunnel2_bgp_asn}'
set protocols bgp ${var.aws_endpoint.bgp_asn} neighbor ${aws_vpn_connection.vyatta.tunnel2_vgw_inside_address} soft-reconfiguration 'inbound'
set protocols bgp ${var.aws_endpoint.bgp_asn} neighbor ${aws_vpn_connection.vyatta.tunnel2_vgw_inside_address} timers holdtime '30'
set protocols bgp ${var.aws_endpoint.bgp_asn} neighbor ${aws_vpn_connection.vyatta.tunnel2_vgw_inside_address} timers keepalive '10'
set protocols bgp ${var.aws_endpoint.bgp_asn} network ${var.vyatta_endpoint.private_subnet}
set vpn ipsec ike-group ${var.vpn_ike_group_name} lifetime '28800'
set vpn ipsec ike-group ${var.vpn_ike_group_name} proposal 1 dh-group '2'
set vpn ipsec ike-group ${var.vpn_ike_group_name} proposal 1 encryption 'aes128'
set vpn ipsec ike-group ${var.vpn_ike_group_name} proposal 1 hash 'sha1'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel1_address} authentication mode 'pre-shared-secret'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel1_address} authentication pre-shared-secret '${aws_vpn_connection.vyatta.tunnel1_preshared_key}'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel1_address} description '${var.vpn_name} Tunnel 2'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel1_address} ike-group '${var.vpn_ike_group_name}'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel1_address} local-address '${var.vyatta_endpoint.public_ip_address}'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel1_address} vti bind 'vti${var.vpn_tunnel_2_interface_id}'
set vpn ipsec site-to-site peer ${aws_vpn_connection.vyatta.tunnel1_address} vti esp-group '${var.vpn_esp_group_name}'
set vpn ipsec ipsec-interfaces interface '${var.vyatta_endpoint.interface}'
set vpn ipsec esp-group ${var.vpn_esp_group_name} compression 'disable'
set vpn ipsec esp-group ${var.vpn_esp_group_name} lifetime '3600'
set vpn ipsec esp-group ${var.vpn_esp_group_name} mode 'tunnel'
set vpn ipsec esp-group ${var.vpn_esp_group_name} pfs 'enable'
set vpn ipsec esp-group ${var.vpn_esp_group_name} proposal 1 encryption 'aes128'
set vpn ipsec esp-group ${var.vpn_esp_group_name} proposal 1 hash 'sha1'
set vpn ipsec ike-group ${var.vpn_esp_group_name} dead-peer-detection action 'restart'
set vpn ipsec ike-group ${var.vpn_esp_group_name} dead-peer-detection interval '15'
set vpn ipsec ike-group ${var.vpn_esp_group_name} dead-peer-detection timeout '30'
set interfaces vti vti${var.vpn_tunnel_2_interface_id} address '${aws_vpn_connection.vyatta.tunnel1_cgw_inside_address}/30'
set interfaces vti vti${var.vpn_tunnel_2_interface_id} description '${var.vpn_name} Tunnel 2'
set interfaces vti vti${var.vpn_tunnel_2_interface_id} mtu '1436'
set protocols bgp ${var.aws_endpoint.bgp_asn} neighbor ${aws_vpn_connection.vyatta.tunnel1_vgw_inside_address} remote-as '${aws_vpn_connection.vyatta.tunnel1_bgp_asn}'
set protocols bgp ${var.aws_endpoint.bgp_asn} neighbor ${aws_vpn_connection.vyatta.tunnel1_vgw_inside_address} soft-reconfiguration 'inbound'
set protocols bgp ${var.aws_endpoint.bgp_asn} neighbor ${aws_vpn_connection.vyatta.tunnel1_vgw_inside_address} timers holdtime '30'
set protocols bgp ${var.aws_endpoint.bgp_asn} neighbor ${aws_vpn_connection.vyatta.tunnel1_vgw_inside_address} timers keepalive '10'
set protocols bgp ${var.aws_endpoint.bgp_asn} network ${var.vyatta_endpoint.private_subnet}
commit
save
  EOT
}
