action :create do
  route53_record new_resource.name do
    name  "#{new_resource.name}.#{new_resource.domain}"
    value new_resource.value
    type  new_resource.type
    zone_id               new_resource.zone_id
    aws_access_key_id     new_resource.credentials[:route53][:aws_access_key_id]
    aws_secret_access_key new_resource.credentials[:route53][:aws_secret_access_key]
    overwrite true
    action :create
  end

  dnsimple_record new_resource.name do
    name     new_resource.name
    content  new_resource.value
    type     new_resource.type
    domain   new_resource.domain
    domain_api_token new_resource.credentials[:dnsimple][:domain_api_token]
    action   :create
  end
end

action :delete do
  route53_record new_resource.name do
    name  "#{new_resource.name}.#{new_resource.domain}"
    value new_resource.value
    type  new_resource.type
    zone_id               new_resource.zone_id
    aws_access_key_id     new_resource.credentials[:route53][:aws_access_key_id]
    aws_secret_access_key new_resource.credentials[:route53][:aws_secret_access_key]
    overwrite true
    action :delete
  end

  dnsimple_record new_resource.name do
    name     new_resource.name
    content  new_resource.value
    type     new_resource.type
    domain   new_resource.domain
    domain_api_token new_resource.credentials[:dnsimple][:domain_api_token]
    action   :destroy
  end
end
