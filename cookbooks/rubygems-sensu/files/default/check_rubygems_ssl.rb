#! /usr/bin/env ruby
#
#   Check Rubygems SSL
#
# DESCRIPTION:
#   Check whether a connection can be established with host using the
#   SSL certificate which comes bundled with rubygems
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#    == If you are passing a glob inclose it in quotes ('')
#   ./check_rubygems_ssl.rb -P './path_to_rubygems/ssl_certs/*/*.pem' -h rubygems.org
#

require 'openssl'
require 'net/http'
require 'sensu-plugin/check/cli'

class CheckRubygemsSSL < Sensu::Plugin::Check::CLI
  option :pem,
         description: 'Path/Glob to PEM file.',
         short: '-P',
         long: '--pem PEM'

  option :host,
         description: 'Host to validate against',
         short: '-h',
         long: '--host HOST'

  def bundled_certificate_store(ssl_cert_glob)
    store = OpenSSL::X509::Store.new

    Dir[ssl_cert_glob].each do |ssl_cert|
      store.add_file ssl_cert
    end

    store
  end

  def validate_opts
    if !config[:pem] || !config[:host]
      unknown 'Path to pem is required' unless config[:pem]
      unknown 'Host name is required' unless config[:host]
    elsif config[:pem]
      unknown 'No such cert found' if Dir.glob(config[:pem]).empty?
    end
  end

  def verify_ok_response(response)
    if response.code == '200'
      ok 'Certificate shall pass'
    else
      warning "Something went wrong while verifing #{config[:host]}: #{response.inspect}"
    end
  end

  def run
    validate_opts
    http = Net::HTTP.new(config[:host], 443)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.cert_store = bundled_certificate_store(config[:pem])
    response = http.get('/')
    verify_ok_response(response)
  rescue Errno::ENOENT, Errno::ETIMEDOUT
    warning "#{config[:host]} seems offline, I can't tell whether ssl would work."
  rescue OpenSSL::SSL::SSLError => e
    # Only fail for certificate verification errors
    if e.message =~ /certificate verify failed/
      critical "#{config[:host]} is not verifiable using the included certificates. Error was: #{e.message}"
    else
      warning "Something went wrong while verifing #{config[:host]}: e.message"
    end
  end
end
