# frozen_string_literal: true

module Terracop
  # Loads a Terraform plan file and transforms it into a Terracop-friendly list
  # of instances.
  class PlanLoader
    class << self
      def load(file)
        plan = decode(file)

        changed_resources = plan['resource_changes'].reject! do |resource|
          resource['change']['actions'] == ['no-op'] ||
            resource['change']['actions'] == ['delete']
        end

        restruct_resources(changed_resources)
      end

      private

      # :nocov:
      def decode(file)
        JSON.parse(`terraform show -json #{file}`)
      rescue JSON::ParserError
        puts 'Terraform failed to decode the plan file.'
        exit
      end
      # :nocov:

      def restruct_resources(resources)
        resources.map do |resource|
          {
            type: resource['type'],
            name: resource['name'],
            index: resource['index'],
            attributes: resource['change']['after']
          }
        end
      end
    end
  end
end
