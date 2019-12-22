# frozen_string_literal: true

require 'json'
require 'yaml'

require 'terracop/cop/aws/ensure_tags'
require 'terracop/cop/aws/open_egress'
require 'terracop/cop/aws/open_ingress'
require 'terracop/cop/aws/unrestricted_egress_ports'
require 'terracop/cop/aws/unrestricted_ingress_ports'

require 'terracop/cop/style/dash_in_resource_name'
require 'terracop/cop/style/resource_type_in_name'

require 'terracop/version'

module Terracop
  # Executes Terracop on a given state file.
  class Runner
    attr_accessor :state

    def initialize(type, file, formatter)
      @formatter = Formatters.const_get(formatter.to_s.capitalize).new

      if file
        load_state_from_file(type, file)
      else
        load_state_from_terraform
      end
    end

    def managed_resources
      resources = state['resources'].select { |res| res['mode'] == 'managed' }

      resources.map do |resource|
        yield resource['type'], resource['name'], resource['instances']
      end
    end

    def run
      all_offenses = managed_resources do |type, name, instances|
        instances.map do |instance|
          Terracop::Cop.run_for(
            type, name, instance['index_key'], instance['attributes']
          )
        end
      end

      by_res = all_offenses.flatten.group_by { |o| "#{o[:type]}.#{o[:name]}" }
      print @formatter.generate(by_res)
    end

    private

    def load_state_from_file(type, file)
      if type == :plan
        puts 'Parsing plans still TODO.'
        exit
      else
        @state = JSON.parse(File.read(file))
      end
    end

    # :nocov:
    def load_state_from_terraform
      @state = JSON.parse(`terraform state pull`)
    rescue JSON::ParserError
      puts 'Run terracop somewhere with a state file or pass it directly ' \
           'with --state FILE'
      exit
    end
    # :nocov:
  end
end
