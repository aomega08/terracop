# frozen_string_literal: true

require 'terracop/cop/base'

module Terracop
  module Cop
    module Aws
      # This cop warns against the use of an evil all encompassing
      # aws_iam_policy_attachment.
      #
      # @example
      #   # bad
      #   resource "aws_iam_policy_attachment" "attach" {
      #     name       = "test-attachment"
      #     policy_arn = aws_iam_policy.policy.arn
      #     users      = [aws_iam_user.user.name]
      #     roles      = [aws_iam_role.role.name]
      #     groups     = [aws_iam_group.group.name]
      #   }
      #
      #   # good
      #   resource "aws_iam_role_policy_attachment" "attach" {
      #     role       = aws_iam_role.role.name
      #     policy_arn = aws_iam_policy.policy.arn
      #   }
      #
      #   resource "aws_iam_user_policy_attachment" "attach" {
      #     user       = aws_iam_user.user.name
      #     policy_arn = aws_iam_policy.policy.arn
      #   }
      #
      #   resource "aws_iam_group_policy_attachment" "attach" {
      #     group      = aws_iam_group.user.name
      #     policy_arn = aws_iam_policy.policy.arn
      #   }
      class IamPolicyAttachment < Base
        register
        applies_to :iam_policy_attachment

        def check
          offense('Use aws_iam_role_policy_attachment, ' \
                  'aws_iam_user_policy_attachment, or ' \
                  'aws_iam_group_policy_attachment instead.')
        end
      end
    end
  end
end
