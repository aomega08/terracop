# frozen_string_literal: true

require 'terracop/cop/base'

module Terracop
  module Cop
    module Aws
      # This cop checks for AWS Security Group rules with no description.
      # Reading terraform code can immediately tell why a rule is in place, but
      # the AWS console is a bit more cryptic and a description can help.
      #
      # @example
      #   # bad
      #   resource "aws_security_group_rule" "rule" {
      #     source_security_group_id = "sg-123456"
      #   }
      #
      #   # good
      #   resource "aws_security_group_rule" "rule" {
      #     source_security_group_id = "sg-123456"
      #     description = "Traffic from the load balancer"
      #   }
      class DescribeSecurityGroupRules < Base
        register
        applies_to :aws_security_group_rule

        def check
          return unless attributes['description'] == ''

          offense('Add a description to security group rules.')
        end
      end
    end
  end
end
