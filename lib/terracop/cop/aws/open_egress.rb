# frozen_string_literal: true

require 'terracop/cop/aws/security_group_rule_cop'

module Terracop
  module Cop
    module Aws
      # This cop warns against an egress rule to 0.0.0.0/0.
      # While very common, and not necessarily an offense, you may want to lock
      # the outbound traffic to some specific addresses (or even other security
      # groups), especially in highly regulated environments.
      #
      # @example
      #   # bad
      #   resource "aws_security_group_rule" "egress" {
      #     type        = "egress"
      #     cidr_blocks = ["0.0.0.0/0"]
      #   }
      #
      #   # good
      #   resource "aws_security_group_rule" "egress" {
      #     type        = "egress"
      #     cidr_blocks = ["10.4.0.0/16"]
      #   }
      #
      #   # better
      #   resource "aws_security_group_rule" "egress" {
      #     type              = "egress"
      #     security_group_id = aws_security_group.destination.id
      #   }
      class OpenEgress < SecurityGroupRuleCop
        register

        def check
          return unless egress? && any_ip?

          offense('Avoid allowing egress traffic to 0.0.0.0/0.', :security)
        end
      end
    end
  end
end
