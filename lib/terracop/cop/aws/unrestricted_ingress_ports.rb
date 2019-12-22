# frozen_string_literal: true

require 'terracop/cop/aws/security_group_rule_cop'

module Terracop
  module Cop
    module Aws
      # This cop warns against ingress security group rules that allow any port.
      # Servers usually run multiple services that might open different ports,
      # exposing them to a range of vulnerabilities. Only allow the specific
      # ports you want to receive traffic on, and no more.
      #
      # @example
      #   # bad
      #   resource "aws_security_group_rule" "ingress" {
      #     type        = "ingress"
      #     from_port   = 0
      #     to_port     = 65535
      #   }
      #
      #   # good
      #   resource "aws_security_group_rule" "ingress" {
      #     type        = "ingress"
      #     from_port   = 443
      #     to_port     = 443
      #   }
      class UnrestrictedIngressPorts < SecurityGroupRuleCop
        register

        def check
          return unless ingress? && (tcp? || udp?) && any_port?

          offense('Limit ingress traffic to small port ranges.', :security)
        end
      end
    end
  end
end
