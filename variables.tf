variable "vpn_name"{
  type = string
}

variable "vpn_tunnel_1_interface_id" {
  default = 0
}

variable "vpn_tunnel_2_interface_id" {
  default = 1
}

variable "vpn_ike_group_name" {
  default = "AWS"
}

variable "vpn_esp_group_name" {
  default = "AWS"
}

variable "vyatta_endpoint" {
  type = object({
    interface         = string
    public_ip_address = string
    private_subnet    = string
  })
  default = {
    interface         = ""
    public_ip_address = ""
    private_subnet    = ""
  }
}

variable "aws_endpoint" {
  type = object({
    vpc_id         = string
    route_table_id = string
    bgp_asn        = number
  })
  default = {
    vpc_id         = ""
    route_table_id = ""
    bgp_asn        = 0
  }
  description = "bgp_asn must be in the range 64512 to 65535"
}
