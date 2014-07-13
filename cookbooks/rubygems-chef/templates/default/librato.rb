# Mostly taken from https://github.com/bscott/chef-handler-librato
# and https://github.com/CozyCo/chef-handler-librato

require 'rubygems'
Gem.clear_paths
require 'librato/metrics'
require 'chef'
require 'chef/handler'

class LibratoReporting < Chef::Handler
  attr_accessor :email, :api_key

  def report
    @source = node.name

    Librato::Metrics.authenticate @email, @api_key

    gauge_metrics = {}
    counter_metrics = {}
    gauge_metrics[:updated_resources] = run_status.updated_resources.length
    gauge_metrics[:all_resources] = run_status.all_resources.length
    gauge_metrics[:elapsed_time] = run_status.elapsed_time.to_i

    if run_status.success?
      counter_metrics[:success] = 1
      counter_metrics[:fail] = 0
    else
      counter_metrics[:success] = 0
      counter_metrics[:fail] = 1
    end

    gauge_metrics.each do |metric, value|
      Chef::Log.debug("#{metric} #{value} #{Time.now}")
      begin
        Librato::Metrics.submit :"chef.#{metric}" => { type: :gauge, value: value, source: @source }
      rescue => e
        puts "#{e}"
      end
    end

    counter_metrics.each do |metric, value|
      Chef::Log.debug("#{metric} #{value} #{Time.now}")
      begin
        Librato::Metrics.submit :"chef.#{metric}" => { type: :counter, value: value, source: @source }
      rescue => e
        puts "#{e}"
      end
    end
    begin
      Librato::Metrics.annotate 'chef.runs', "Chef run #{Time.now}",
                                source: @source,
                                description: "updated #{run_status.updated_resources.length} resources",
                                start_time: run_status.start_time.to_i,
                                end_time: run_status.end_time.to_i
    rescue => e
      puts "#{e}"
    end
  end
end

librato_handler = LibratoReporting.new
librato_handler.email = '<%= @email %>'
librato_handler.api_key = '<%= @api_key %>'
report_handlers << librato_handler
exception_handlers << librato_handler
