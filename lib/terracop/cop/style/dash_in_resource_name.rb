# frozen_string_literal: true

require 'terracop/cop/base'

module Terracop
  module Cop
    module Style
      # This cop checks for the use of dashes in terraform resource names.
      # Terraform uses underscores for resource types and attributes.
      # Using dashes for resource names makes for awkward combinations.
      #
      # @example
      #   # bad
      #   resource "aws_security_group" "load-balancer" { }
      #
      #   # good
      #   resource "aws_security_group" "load_balancer" { }
      #
      # @note
      #   When you rename a resource terraform will destroy and recreate it.
      #   Use `terraform mv` on the state file to avoid this from happening.
      class DashInResourceName < Base
        register

        MSG = 'Use underscores in terraform resource names instead of dashes.'

        def check
          return unless name.index('-')

          offense(MSG)
        end
      end
    end
  end
end
