# frozen_string_literal: true

require 'terracop/cop/aws/security_group_rule_cop'

module Terracop
  module Cop
    module Aws
      # This cop warns against egress security group rules that allow any port.
      # This would, for example, allow an attacker to use your machine to send
      # spam emails, since you left port 25 outbound open.
      #
      # @example
      #   # bad
      #   resource "aws_security_group_rule" "egress" {
      #     type        = "egress"
      #     from_port   = 0
      #     to_port     = 65535
      #   }
      #
      #   # good
      #   resource "aws_security_group_rule" "egress" {
      #     type        = "egress"
      #     from_port   = 443
      #     to_port     = 443
      #   }
      class UnrestrictedEgressPorts < SecurityGroupRuleCop
        register

        def check
          return unless egress? && (tcp? || udp?) && any_port?

          offense('Limit egress traffic to small port ranges.', :security)
        end
      end
    end
  end
end
