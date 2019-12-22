# frozen_string_literal: true

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

    def run
      offenses = @state.map do |instance|
        Terracop::Cop.run_for(
          instance[:type], instance[:name],
          instance[:index], instance[:attributes]
        )
      end

      by_res = offenses.flatten.group_by { |o| "#{o[:type]}.#{o[:name]}" }
      print @formatter.generate(by_res)
    end

    private

    def load_state_from_file(type, file)
      @state = if type == :plan
                 PlanLoader.load(file)
               else
                 StateLoader.load(file)
               end
    end

    # :nocov:
    def load_state_from_terraform
      @state = StateLoader.load_from_text(`terraform state pull`)
    rescue JSON::ParserError
      puts 'Run terracop somewhere with a state file or pass it directly ' \
           'with --state FILE'
      exit
    end
    # :nocov:
  end
end
