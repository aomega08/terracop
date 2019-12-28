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
      #   resource "aws_launch_configuration" "lc" {}
      #
      #   resource "aws_autoscaling_group" "asg" {
      #     launch_configuration = aws_launch_configuration.lc.name
      #   }
      #
      #   # good
      #   resource "aws_launch_template" "tpl" {}
      #
      #   resource "aws_autoscaling_group" "asg" {
      #     launch_template {
      #       id      = aws_launch_template.tpl.id
      #       version = "$Latest"
      #     }
      #   }
      class PreferLaunchTemplates < SecurityGroupRuleCop
        register
        applies_to :aws_launch_configuration, :aws_autoscaling_group

        def check
          if type == 'aws_launch_configuration' ||
             attributes['launch_configuration']
            offense('Prefer Launch Templates to Launch Configurations.')
          end
        end
      end
    end
  end
end
