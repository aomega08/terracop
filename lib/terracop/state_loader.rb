# frozen_string_literal: true

module Terracop
  # Loads a Terraform state file and transforms it into a Terracop-friendly list
  # of instances.
  class StateLoader
    class << self
      def load(file)
        state = File.read(file)
        load_from_text(state)
      end

      def load_from_text(text)
        state = JSON.parse(text)

        managed_resources = state['resources'].select do |resource|
          resource['mode'] == 'managed'
        end

        flatten_instances(managed_resources)
      end

      private

      def flatten_instances(resources)
        resources.map do |resource|
          resource['instances'].map do |instance|
            {
              type: resource['type'],
              name: resource['name'],
              index: instance['index_key'],
              attributes: instance['attributes']
            }
          end
        end.flatten
      end
    end
  end
end
