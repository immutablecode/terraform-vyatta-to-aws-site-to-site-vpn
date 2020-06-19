resource "aws_customer_gateway" "vyatta" {
  bgp_asn    = var.aws_endpoint.bgp_asn
  ip_address = var.vyatta_endpoint.public_ip_address
  type       = "ipsec.1"

  tags = {
    Name = var.vpn_name
  }
}

resource "aws_vpn_gateway" "vyatta" {
  vpc_id = var.aws_endpoint.vpc_id

  tags = {
    Name = var.vpn_name
  }
}

resource "aws_vpn_connection" "vyatta" {
  vpn_gateway_id      = aws_vpn_gateway.vyatta.id
  customer_gateway_id = aws_customer_gateway.vyatta.id
  type                = "ipsec.1"

  tags = {
    Name = var.vpn_name
  }
}

resource "aws_vpn_gateway_route_propagation" "vyatta" {
  vpn_gateway_id = aws_vpn_gateway.vyatta.id
  route_table_id = var.aws_endpoint.route_table_id
}
