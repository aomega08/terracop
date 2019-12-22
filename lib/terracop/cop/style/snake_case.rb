# frozen_string_literal: true

require 'terracop/cop/base'

module Terracop
  module Cop
    module Style
      # This cop checks terraform resource names that are using CamelCase or
      # in general, contain capital letters. Terraform prefers snake_case.
      #
      # @example
      #   # bad
      #   resource "aws_security_group" "LoadBalancer" { }
      #   resource "aws_security_group" "app_ALB" { }
      #
      #   # good
      #   resource "aws_security_group" "load_balancer" { }
      #   resource "aws_security_group_rule" "app_alb" { }
      #
      # @note
      #   When you rename a resource terraform will destroy and recreate it.
      #   Use `terraform mv` on the state file to avoid this from happening.
      class SnakeCase < Base
        register

        def check
          # Allow dashes here as there is another cop to complain about that.
          return if name =~ /^[\da-z_\-]+$/

          offense 'Use snake_case for resource names.'
        end
      end
    end
  end
end
