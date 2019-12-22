# frozen_string_literal: true

require 'terracop/cop/aws/security_group_rule_cop'

module Terracop
  module Cop
    module Aws
      # This cop warns against an ingress rule from 0.0.0.0/0 on port 22 (SSH).
      # That is a Very Bad Idea™.
      #
      # @example
      #   # bad
      #   resource "aws_security_group_rule" "ingress" {
      #     type        = "ingress"
      #     cidr_blocks = ["0.0.0.0/0"]
      #     # Notice this port range includes 22
      #     from_port   = 10
      #     to_port     = 30
      #   }
      #
      #   # good
      #   resource "aws_security_group_rule" "ingress" {
      #     type       = "ingress"
      #     cidr_blocks = ["1.2.3.4/32"]
      #     from_port   = 22
      #     to_port     = 22
      #   }
      class OpenSsh < SecurityGroupRuleCop
        register

        def check
          return unless ingress? && any_ip? && tcp? && port?(22)

          offense('Do not leave port 22 (SSH) open to the world.', :security)
        end
      end
    end
  end
end
