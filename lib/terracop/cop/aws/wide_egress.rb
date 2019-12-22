# frozen_string_literal: true

require 'terracop/cop/aws/security_group_rule_cop'

module Terracop
  module Cop
    module Aws
      # This cop warns against egress security group rules that allow very wide
      # address ranges.
      # This goes hand in hand with OpenEgress, but also warns against blocks
      # like 10.0.0.0/8.
      # Always pick the smallest possible choice of sources/destinations.
      #
      # @example
      #   # bad
      #   resource "aws_security_group_rule" "egress" {
      #     type        = "egress"
      #     cidr_blocks = ["10.0.0.0/8"]
      #   }
      #
      #   # good
      #   resource "aws_security_group_rule" "egress" {
      #     type        = "egress"
      #     cidr_blocks = ["10.4.3.0/24"]
      #   }
      #
      #   # better
      #   resource "aws_security_group_rule" "egress" {
      #     type              = "egress"
      #     security_group_id = aws_security_group.destination.id
      #   }
      class WideEgress < SecurityGroupRuleCop
        register

        MSG = 'Avoid allowing egress traffic from wide address blocks ' \
              '(%<cidr>s).'

        def check
          return unless egress?

          attributes['cidr_blocks'].each do |cidr|
            # Handled by OpenEgress
            next if cidr == '0.0.0.0/0'

            _, bits = cidr.split('/')

            offense(format(MSG, cidr: cidr), :security) if bits.to_i < 16
          end
        end
      end
    end
  end
end
