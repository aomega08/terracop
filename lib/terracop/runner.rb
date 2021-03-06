# frozen_string_literal: true

module Terracop
  # Executes Terracop on a given state file.
  class Runner
    def initialize(type, file, formatter)
      @formatter = Formatters.const_get(formatter.to_s.capitalize).new

      @type = type
      @file = file
    end

    def run
      offenses = state.map do |instance|
        Terracop::Cop.run_for(
          instance[:type], instance[:name],
          instance[:index], instance[:attributes]
        )
      end

      print formatted(offenses)

      offenses.flatten.count
    end

    def state
      @state ||= begin
        if @file
          load_state_from_file(@type, @file)
        else
          load_state_from_terraform
        end
      end
    end

    private

    def load_state_from_file(type, file)
      if type == :plan
        PlanLoader.load(file)
      else
        StateLoader.load(file)
      end
    end

    # :nocov:
    def load_state_from_terraform
      StateLoader.load_from_text(`terraform state pull`)
    rescue JSON::ParserError
      puts 'Run terracop somewhere with a state file or pass it directly ' \
           'with --state FILE'
      exit
    end
    # :nocov:

    def formatted(offenses)
      by_res = offenses.flatten.group_by { |o| "#{o[:type]}.#{o[:name]}" }
      @formatter.generate(by_res)
    end
  end
end
