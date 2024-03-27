resource "ciscomcd_address_object" "tag_prod_address" {
  name             = "tag-prod"
  type             = "DYNAMIC_USER_DEFINED_TAG"
  csp_account_name = ciscomcd_cloud_account.mcd_cloud_account.name
  tag_list {
    tag_key        = "Category"
    tag_value      = "prod"
    resource_type  = "RESOURCE_INSTANCE"
  }
  depends_on = [ciscomcd_cloud_account.mcd_cloud_account]
}

resource "ciscomcd_address_object" "aws_services_address" {
  name                  = "aws-services"
  type                  = "DYNAMIC_SERVICE_ENDPOINTS"
  csp_account_name      = ciscomcd_cloud_account.mcd_cloud_account.name
  service_endpoint_name = "AMAZON"
  region                = data.aws_region.current.name
  depends_on            = [ciscomcd_cloud_account.mcd_cloud_account]
}

resource "ciscomcd_profile_dlp" "block-social-security_profile" {
  name = "block-social-security"
  dlp_filter_list {
    count           = 2
    action          = "Deny Log"
    static_patterns = ["US Social Security Number"]
  }
  depends_on = [ciscomcd_cloud_account.mcd_cloud_account]
}

resource "ciscomcd_profile_urlfilter" "url_github_profile" {
  name = "block-github-repos"
  url_filter_list {
    url_list = ["http.*github.com/CiscoDevNet.*"]
    policy   = "Allow Log"
  }
  url_filter_list {
    url_list      = ["http.*github.com/.*"]
    policy        = "Deny Log"
    return_status = 503
  }
  uncategorized_url_filter {
    policy        = "Deny Log"
    return_status = 503
  }
  default_url_filter {
    policy        = "Deny No Log"
    return_status = 503
  }
  deny_response = "The URL being accessed has been blocked for security reasons"
  depends_on    = [ciscomcd_cloud_account.mcd_cloud_account]
}

data "ciscomcd_address_object" "any_private_rfc1918_address" {
  name = "any-private-rfc1918"
}

data "ciscomcd_service_object" "egress_forward_proxy_service" {
  name = "ciscomcd-sample-egress-forward-proxy"
}

data "ciscomcd_profile_network_intrusion" "ciscomcd_sample_ips_balanced_alert" {
  name = "ciscomcd-sample-ips-balanced-alert"
}

data "ciscomcd_profile_malicious_ip" "ciscomcd_sample_malicious_ips" {
  name = "ciscomcd-sample-malicious-ips"
}

data "ciscomcd_profile_fqdn" "ciscomcd_sample_malicious_fqdns" {
  name = "ciscomcd-sample-malicious-fqdns"
}

resource "ciscomcd_policy_rule_set" "mcd_egress_rule_set_custom" {
  name = "mcd-egress-ruleset-custom"
}

resource "ciscomcd_policy_rules" "egress_policy_rules_custom" {
  rule_set_id = ciscomcd_policy_rule_set.mcd_egress_rule_set_custom.id
  rule {
    name        = "egress-aws-services"
    type        = "Forwarding"
    service     = data.ciscomcd_service_object.ciscomcd_sample_egress_forwarding_snat.id
    source      = data.ciscomcd_address_object.any_private_rfc1918_address.id
    destination = ciscomcd_address_object.aws_services_address.id
    action      = "Allow Log"
    state       = "ENABLED"
  }
  rule {
    name                      = "egress-prod"
    type                      = "ForwardProxy"
    service                   = data.ciscomcd_service_object.egress_forward_proxy_service.id
    source                    = ciscomcd_address_object.tag_prod_address.id
    destination               = data.ciscomcd_address_object.any_address.id
    network_intrusion_profile = data.ciscomcd_profile_network_intrusion.ciscomcd_sample_ips_balanced_alert.id
    dlp_profile               = ciscomcd_profile_dlp.block-social-security_profile.id
    url_filter                = ciscomcd_profile_urlfilter.url_github_profile.id
    action                    = "Allow Log"
    state       = "ENABLED"
  }
  rule {
    name                 = "egress-tcp-forwarding-allow"
    type                 = "Forwarding"
    service              = data.ciscomcd_service_object.ciscomcd_sample_egress_forwarding_snat.id
    source               = data.ciscomcd_address_object.any_address.id
    destination          = data.ciscomcd_address_object.any_address.id
    malicious_ip_profile = data.ciscomcd_profile_malicious_ip.ciscomcd_sample_malicious_ips.id
    fqdn_filter_profile  = data.ciscomcd_profile_fqdn.ciscomcd_sample_malicious_fqdns.id
    action               = "Allow Log"
    state       = "ENABLED"
  }
  rule {
    name                 = "egress-udp-forwarding-allow"
    type                 = "Forwarding"
    service              = data.ciscomcd_service_object.ciscomcd_sample_egress_udp_forwarding_snat.id
    source               = data.ciscomcd_address_object.any_address.id
    destination          = data.ciscomcd_address_object.any_address.id
    malicious_ip_profile = data.ciscomcd_profile_malicious_ip.ciscomcd_sample_malicious_ips.id
    fqdn_filter_profile  = data.ciscomcd_profile_fqdn.ciscomcd_sample_malicious_fqdns.id
    action               = "Allow Log"
    state       = "ENABLED"
  }
  depends_on = [
    ciscomcd_gateway.mcd_gateway,
    ciscomcd_cloud_account.mcd_cloud_account
  ]
}

