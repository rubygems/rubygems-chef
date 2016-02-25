action :create do
  route53_record new_resource.name do
    name  "#{new_resource.name}.#{new_resource.domain}"
    value new_resource.value
    type  new_resource.type
    ttl   new_resource.ttl
    zone_id               new_resource.zone_id
    aws_access_key_id     new_resource.credentials[:route53][:aws_access_key_id]
    aws_secret_access_key new_resource.credentials[:route53][:aws_secret_access_key]
    overwrite true
    action :create
    ignore_failure true
  end

  dnsimple_record new_resource.name do
    action   :create
    name     new_resource.name
    content  new_resource.value
    type     new_resource.type
    ttl      new_resource.ttl
    domain   new_resource.domain
    domain_api_token new_resource.credentials[:dnsimple][:domain_api_token]
    ignore_failure true
  end
end

action :delete do
  route53_record new_resource.name do
    name  "#{new_resource.name}.#{new_resource.domain}"
    value new_resource.value
    type  new_resource.type
    ttl   new_resource.ttl
    zone_id               new_resource.zone_id
    aws_access_key_id     new_resource.credentials[:route53][:aws_access_key_id]
    aws_secret_access_key new_resource.credentials[:route53][:aws_secret_access_key]
    overwrite true
    action :delete
    ignore_failure true
  end

  dnsimple_record new_resource.name do
    action   :destroy
    name     new_resource.name
    content  new_resource.value
    type     new_resource.type
    ttl      new_resource.ttl
    domain   new_resource.domain
    domain_api_token new_resource.credentials[:dnsimple][:domain_api_token]
    ignore_failure true
  end
end
