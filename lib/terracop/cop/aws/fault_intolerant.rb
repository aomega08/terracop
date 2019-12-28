# frozen_string_literal: true

require 'terracop/cop/base'

module Terracop
  module Cop
    module Aws
      # This cop checks for Autoscaling Groups that can only launch instances
      # in a specific Availability Zone. This creates an availability risk,
      # as if that AZ is lost, the ASG will not be able to launch instances
      # anywhere else.
      #
      # @example
      #   # bad
      #   resource "aws_autoscaling_group" "asg" {
      #     vpc_zone_identifier = ["subnet-123"]
      #   }
      #
      #   # good
      #   resource "aws_autoscaling_group" "asg" {
      #     # Note that to pass this cop, the two subnets must live in
      #     # different AZs.
      #     vpc_zone_identifier = ["subnet-123", "subnet-456"]
      #   }
      class FaultIntolerant < Base
        register
        applies_to :aws_autoscaling_group

        MSG = 'This Autoscaling Group can launch instances in only one AZ ' \
              '(%<az>s). This setup would not tolerate the loss of that AZ.'

        def check
          return unless attributes['availability_zones'].count < 2

          offense(format(MSG, az: attributes['availability_zones'][0]))
        end
      end
    end
  end
end
