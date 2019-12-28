# frozen_string_literal: true

require 'terracop/cop/base'

module Terracop
  module Cop
    module Aws
      # This cop warns against the use of inline group/role/user policies.
      # Inline policies tend to be copy/pasted, sometimes with minor changes
      # and are not shown in the "Policies" tab of AWS IAM.
      #
      # @example
      #   # bad
      #   resource "aws_role" "role" { }
      #
      #   resource "aws_iam_role_policy" "policy" {
      #     role = aws_role.role.id
      #     name = "policy"
      #
      #     policy = <some policy>
      #   }
      #
      #   # good
      #   resource "aws_role" "role" { }
      #
      #   resource "aws_iam_policy" "policy" {
      #     name        = "test-policy"
      #
      #     policy = <some policy>
      #   }
      #
      #   resource "aws_iam_role_policy_attachment" "attach" {
      #     role       = aws_iam_role.role.name
      #     policy_arn = aws_iam_policy.policy.arn
      #   }
      class IamInlinePolicy < Base
        register
        applies_to :aws_iam_group_policy, :aws_iam_role_policy,
                   :aws_iam_user_policy

        def check
          entity = type.scan(/aws_iam_(.+)_policy/).first.first
          offense("Use aws_iam_#{entity}_policy_attachment instead of " \
                  "attaching inline policies with aws_iam_#{entity}_policy.")
        end
      end
    end
  end
end
