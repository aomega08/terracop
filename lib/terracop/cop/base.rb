# frozen_string_literal: true

module Terracop
  # This namespace holds all the individual Cop (checks).
  module Cop
    class << self
      def all
        @all ||= []
      end

      def run_for(type, name, index, attributes)
        offenses = all.map do |cop|
          cop.run(type, name, index, attributes)
        end

        offenses.flatten.compact
      end
    end

    # Base class for all cops.
    class Base
      attr_accessor :type, :name, :index, :attributes

      class << self
        def run(type, name, index, attributes)
          return unless applies_to?(type, name)

          cop = new(type, name, index, attributes)
          cop.check
          cop.offenses
        end

        def cop_name
          name.gsub(/^Terracop::Cop::/, '').gsub('::', '/')
        end

        def config
          config = Terracop.config[cop_name] || {}
          config['Enabled'] = config['Enabled'].nil? ? true : config['Enabled']
          config
        end

        protected

        def register
          Terracop::Cop.all << self
        end

        def applies_to(*types)
          @applies_to ||= []
          @applies_to += types.map(&:to_s)
        end

        def applies_to?(type, name)
          return unless enabled?
          return unless @applies_to.nil? || @applies_to.include?(type)

          !excludes?(type, name)
        end

        def enabled?
          config['Enabled']
        end

        def excludes?(type, name)
          excludes = config['Exclude'] || []
          excludes.each do |rule|
            return true if ["#{type}.*", "#{type}.#{name}"].include?(rule)
          end

          false
        end
      end

      def initialize(type, name, index, attributes)
        self.type = type
        self.name = name
        self.index = index
        self.attributes = attributes
        @offenses = []
      end

      def human_name
        index ? "#{name}[#{index}]" : name
      end

      def check
        message = "#{self.class.name} does not implement the #check method"
        raise NotImplementedError, message
      end

      def offense(message, severity = :convention)
        @offenses << {
          cop_name: self.class.cop_name,
          severity: severity,
          type: type,
          name: human_name,
          message: message
        }
      end

      attr_reader :offenses
    end
  end
end
