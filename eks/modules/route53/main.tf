resource "aws_route53_zone" "staging" {
  name = "staging.eks-cluster.com"
}


resource "aws_route53_record" "ns-us-east-1-staging" {
  zone_id = aws_route53_zone.staging.zone_id

  name = "us-east-1"
  type = "NS"
  ttl  = "300"

  records = aws_route53_zone.us-east-1-staging.name_servers
}


resource "aws_route53_record" "dns" {
  zone_id = aws_route53_zone.us-east-1-staging.zone_id
  name    = "prometheus-"
  type    = "A"

  alias {
    name                   = aws_lb.og_internal.dns_name
    zone_id                = aws_lb.og_internal.zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_resolver_endpoint" "gcp_private_dns_resolver" {
  name      = "gcp-private-dns-resolver"
  direction = "OUTBOUND"

  security_group_ids = [
    module.private_dns_sg.this_security_group_id,
  ]

  ip_address {
    subnet_id = sort(data.aws_subnet_ids.services_private_a.ids)[0]
  }

  ip_address {
    subnet_id = sort(data.aws_subnet_ids.services_private_b.ids)[0]
  }

  ip_address {
    subnet_id = sort(data.aws_subnet_ids.services_private_f.ids)[0]
  }

  tags = {
    Name        = "gcp-private-dns-resolver"
    Environment = "staging"
    Repo        = "eks-cluster"
  }
}


resource "aws_route53_resolver_rule" "fwd" {
  domain_name          = "eks-cluster.private"
  name                 = "forward-to-gcp"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.gcp_private_dns_resolver.id

  target_ip {
    ip = "10.80.0.37"
  }

  target_ip {
    ip = "10.82.0.62"
  }

  target_ip {
    ip = "10.240.0.10"
  }

  target_ip {
    ip = "10.81.0.9"
  }

  tags = {
    Name        = "gcp-private-dns-rule"
    Environment = "staging"
    Repo        = "eks-cluster"
  }
}

resource "aws_route53_resolver_rule_association" "resolver_rule" {
  resolver_rule_id = aws_route53_resolver_rule.fwd.id
  vpc_id           = var.current_staging_east_vpc_id
}
