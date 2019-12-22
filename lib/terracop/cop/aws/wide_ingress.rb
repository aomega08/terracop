# frozen_string_literal: true

require 'terracop/cop/aws/security_group_rule_cop'

module Terracop
  module Cop
    module Aws
      # This cop warns against ingress security group rules that allow very wide
      # address ranges.
      # This goes hand in hand with OpenIngress, but also warns against blocks
      # like 10.0.0.0/8.
      # Always pick the smallest possible choice of sources/destinations.
      #
      # @example
      #   # bad
      #   resource "aws_security_group_rule" "ingress" {
      #     type        = "ingress"
      #     cidr_blocks = ["10.0.0.0/8"]
      #   }
      #
      #   # good
      #   resource "aws_security_group_rule" "ingress" {
      #     type        = "ingress"
      #     cidr_blocks = ["10.4.3.0/24"]
      #   }
      #
      #   # better
      #   resource "aws_security_group_rule" "ingress" {
      #     type              = "ingress"
      #     security_group_id = aws_security_group.destination.id
      #   }
      class WideIngress < SecurityGroupRuleCop
        register

        MSG = 'Avoid allowing ingress traffic from wide address blocks ' \
              '(%<cidr>s).'

        def check
          return unless ingress?

          attributes['cidr_blocks'].each do |cidr|
            # Handled by OpenIngress
            next if cidr == '0.0.0.0/0'

            _, bits = cidr.split('/')

            offense(format(MSG, cidr: cidr), :security) if bits.to_i < 16
          end
        end
      end
    end
  end
end
