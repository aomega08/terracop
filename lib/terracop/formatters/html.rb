# frozen_string_literal: true

require 'erb'

module Terracop
  module Formatters
    # Generates a single page HTML report listing all the offenses.
    # Ideal for human readable reports.
    class Html
      def generate(resources)
        template = ERB.new(File.read(File.join(__dir__, './report.html.erb')))
        template.result(binding)
      end
    end
  end
end
