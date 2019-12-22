# frozen_string_literal: true

require 'json'

module Terracop
  module Formatters
    # Generates a JSON document listing all the offenses.
    # Ideal to generate ouputs to be digested by other tools in a CI pipeline.
    class Json
      def generate(resources)
        {
          metadata: meta,
          resources: build_resources(resources),
          summary: {
            offense_count: resources.values.map(&:count).sum,
            resource_count: resources.count
          }
        }.to_json
      end

      private

      def meta
        {
          terracop_version: Terracop::VERSION,
          ruby_engine: RUBY_ENGINE,
          ruby_version: RUBY_ENGINE_VERSION,
          ruby_patchlevel: RUBY_PATCHLEVEL,
          ruby_platform: RUBY_PLATFORM
        }
      end

      def build_resources(resources)
        resources.map do |resource, offenses|
          {
            resource: resource,
            offsenses: build_offenses(offenses)
          }
        end
      end

      def build_offenses(offenses)
        offenses.map do |offense|
          {
            severity: offense[:severity],
            cop_name: offense[:cop_name],
            message: offense[:message]
          }
        end
      end
    end
  end
end
