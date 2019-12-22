# frozen_string_literal: true

require 'terracop/cop/aws/security_group_rule_cop'

module Terracop
  module Cop
    module Aws
      # This cop warns against an ingress rule from 0.0.0.0/0.
      # With a couple of specific exceptions, you don't want to allow traffic
      # from anywhere in the world to most of your infrastructure.
      # A common exception is the external Load Balancer receiving traffic
      # for a website. Use the `Except` configuration to whitelist that specific
      # rule.
      #
      # @example
      #   # bad
      #   resource "aws_security_group_rule" "ingress" {
      #     type        = "ingress"
      #     cidr_blocks = ["0.0.0.0/0"]
      #   }
      #
      #   # good
      #   resource "aws_security_group_rule" "ingress" {
      #     type        = "ingress"
      #     cidr_blocks = ["10.4.0.0/16"]
      #   }
      #
      #   # better
      #   resource "aws_security_group_rule" "ingress" {
      #     type              = "ingress"
      #     security_group_id = aws_security_group.source.id
      #   }
      class OpenIngress < SecurityGroupRuleCop
        register

        def check
          return unless ingress? && any_ip?

          offense('Avoid allowing ingress traffic from 0.0.0.0/0.', :security)
        end
      end
    end
  end
end
