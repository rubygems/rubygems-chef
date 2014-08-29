#
# Author:: Dell Cloud Manager OSS
# Copyright:: Dell, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "chef"
require "chef/handler"

begin
  require "slackr"
rescue LoadError
  Chef::Log.debug("Chef slack_handler requires `slackr` gem")
end

require "timeout"

class Chef::Handler::Slack < Chef::Handler
  attr_reader :team, :api_key, :config, :timeout

  def initialize(config = {})
    @config  = config.dup
    @team    = @config.delete(:team)
    @api_key = @config.delete(:api_key)
    @timeout = @config.delete(:timeout) || 15
    @gist_url = nil
    @config.delete(:icon_emoji) if @config[:icon_url] && @config[:icon_emoji]
  end

  def report
    begin
      Timeout::timeout(@timeout) do
        Chef::Log.debug("Sending report to Slack ##{config[:channel]}@#{team}.slack.com")
        @timestamp = Time.now.getutc
        create_gist
        slack_message("Chef client run #{run_status_human_readable} on #{node.name}: #{@gist_url}")
      end
    rescue Exception => e
      Chef::Log.debug("Failed to send message to Slack: #{e.message}")
    end
  end

  private

  def formatted_run_list
    node.run_list.map { |r| r.type == :role ? r.name : r.to_s }.join(", ")
  end

  def formatted_gist
    ip_address = node.has_key?(:cloud) ? node.cloud.public_ipv4 : node.ipaddress
    node_info = [
      "Node: #{node.name} (#{ip_address})",
      "Run list: #{node.run_list}",
      "All roles: #{node.roles.join(', ')}"
    ].join("\n")
    [
      node_info,
      run_status.formatted_exception,
      Array(backtrace).join("\n")
    ].join("\n\n")
  end

  def create_gist
    begin
      Timeout::timeout(10) do
        uri = URI.parse("https://api.github.com/gists")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        request.body = {
          "description" => "Chef run failed on #{node.name} @ #{@timestamp}",
          "public" => false,
          "files" => {
            "chef_exception.txt" => {
              "content" => formatted_gist
            }
          }
        }.to_json
        response = http.request(request)
        @gist_url = JSON.parse(response.body)["html_url"]
      end
      Chef::Log.info("Created a Gist @ #{@gist_url}")
    rescue Timeout::Error
      Chef::Log.error("Timed out while attempting to create a Gist")
    rescue => error
      Chef::Log.error("Unexpected error while attempting to create a Gist: #{error.message} #{error.backtrace.inspect}")
    end
  end

  def slack_message(content)
    slack = Slackr::Webhook.new(team, api_key, config)
    slack.say(content)
  end

  def run_status_human_readable
    run_status.success? ? "succeeded" : "failed"
  end

end

handler = Chef::Handler::Slack.new(
  team: '<%= @team %>',
  api_key: '<%= @api_key %>',
  channel: '<%= @channel %>',
  username: '<%= @username %>',
  icon_url: '<%= @icon_url %>'
)
# report_handlers << handler
exception_handlers << handler
