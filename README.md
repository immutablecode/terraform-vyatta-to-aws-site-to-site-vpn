Vyatta to AWS site-to-site VPN Terraform Module
===============================================

A terraform module for creating AWS site-to-site VPN infrastructure that outputs a script for completion of the vpn setup on a Vyatta compatible device such a a Ubiquiti EdgeRouter or USG.

```hcl-terraform
resource "aws_vpc" "work" {
  cidr_block = "10.0.0.0/16"
}

module "home_to_work_vpn" {
  source = "git@github.com:immutablecode/terraform_vyatta_to_aws_site_to_site_vpn.git"
  
  vpn_name = "Home2Work"
  
  vyatta_endpoint = {
    interface         = "eth0"
    public_ip_address = "17.5.7.8"       // Public home ip on eth0 of Vyatta device
    private_subnet    = "192.168.1.0/24" // Private home subnet
  }

  aws_endpoint = {
    vpc_id         = aws_vpc.work.id
    route_table_id = aws_vpc.work.default_route_table_id
    bgp_asn        = 64512 // must be in the range 64512 to 65535 
  }
}

resource "local_file" "vyatta_script" {
  filename = "vyatta_script.txt"
  content  = module.home_to_work_vpn.vyatta_script
}
```

By default the output script sets up 2 vti interfaces for the tunnels; `vti0` and `vti1` on the Vyatta device. If you wish to have multiple VPN setups on the same Vyatta device this is made possible by explicitly setting interface id values as follows:

```hcl-terraform
module "home_to_play_vpn" {
  source = "git@github.com:immutablecode/terraform_vyatta_to_aws_site_to_site_vpn.git"

  vpn_name = "Home2Play"

  vpn_tunnel_1_interface_id = 2
  vpn_tunnel_2_interface_id = 3    

  ...

  aws_endpoint = {
      ...
      bgp_asn = 64513
      ...
  }
}
```

Note it is also necessary to set a different bgp_asn per VPN. The above settings would result in the vti interfaces being set up as `vti2` and `vti3` for the Home2Play VPN.

#### Load Balancing

If you are load balancing outgoing traffic from your Vyatta based device you will need to run an additional script to ensure VPN traffic always goes out on the correct interface.

For example if you are load balancing outgoing traffic on both `eth0` and `eth1`, and `eth0` has VPN set up with public ip address `17.5.7.8`, you need to ensure `eth1` traffic bound for the vpn tunnels is redirected:

```hcl-terraform
resource "local_file" "additional_vyatta_script" {
  filename = "additional_vyatta_script.txt"
  content  = <<EOF
configure
set protocols static table 1 route ${module.home_to_work.tunnel1_address}/32 next-hop 17.5.7.8
set protocols static table 1 route ${module.home_to_work.tunnel2_address}/32 next-hop 17.5.7.8
set load-balance group G interface eth1 route table 1
commit
save
EOF
}
```