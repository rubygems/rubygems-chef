actions :create, :delete
default_action :create

attribute :name,             kind_of: String, required: true, name_attribute: true
attribute :domain,           kind_of: String, default: nil
attribute :zone_id,          kind_of: String, default: nil
attribute :type,             kind_of: String, equal_to: %w(A CNAME ALIAS MX SPF URL TXT NS SRV NAPTR PTR AAA SSHFP HFINO)
attribute :value,            kind_of: String
attribute :ttl,              kind_of: Integer, default: 3600
attribute :priority,         kind_of: Integer
attribute :credentials,      kind_of: Hash
