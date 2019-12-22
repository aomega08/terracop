# frozen_string_literal: true

require 'terracop/cop/base'

module Terracop
  module Cop
    module Style
      # This cop checks terraform resource names that include the type in them.
      # This makes for very long and redundant names.
      #
      # @example
      #   # bad
      #   resource "aws_security_group" "load_balancer_security_group" { }
      #   resource "aws_security_group" "load_balancer_sg" { }
      #   resource "aws_security_group_rule" "ingress_rule" { }
      #
      #   # good
      #   resource "aws_security_group" "load_balancer" { }
      #   resource "aws_security_group_rule" "ingress" { }
      #
      # @note
      #   When you rename a resource terraform will destroy and recreate it.
      #   Use `terraform mv` on the state file to avoid this from happening.
      class ResourceTypeInName < Base
        register

        BLACKLIST = {
          'aws_alb' => %w[alb lb load_balancer],
          'aws_alb_listener' => %w[listener],
          'aws_alb_target_group' => %w[tg],
          'aws_autoscaling_group' => %w[asg],
          'aws_cloudwatch_metric_alarm' => %w[metric alarm],
          'aws_iam_instance_profile' => %w[profile],
          'aws_iam_role' => %w[role],
          'aws_iam_role_policy' => %w[policy],
          'aws_route53_record' => %w[record],
          'aws_security_group' => %w[sg group security_group],
          'aws_security_group_rule' => %w[rule]
        }.freeze

        def check
          blacklist = BLACKLIST[type]
          blacklist&.each do |word|
            if name.downcase.gsub('-', '_').include?(word)
              offense 'Do not include the resource type in its name.'
              return
            end
          end
        end
      end
    end
  end
end
