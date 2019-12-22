# frozen_string_literal: true

require 'colorize'

module Terracop
  module Formatters
    # Default CLI-friendly output formatter.
    class Default
      def generate(resources)
        out = []
        resources.each do |resource, offenses|
          out << "#{resource.cyan}:"

          offenses.each do |offense|
            out << "#{offense[:cop_name].yellow}: #{offense[:message]}"
          end

          out << ''
        end

        out.join("\n")
      end
    end
  end
end
