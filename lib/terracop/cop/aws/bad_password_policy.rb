# frozen_string_literal: true

require 'terracop/cop/base'

module Terracop
  module Cop
    module Aws
      # This cop warns against a password policy that goes against industry
      # best practices. Ideally the password policy should be strict enough
      # to require the use of a password manager, and never expire passwords.
      #
      # @example
      #   # bad
      #   resource "aws_iam_account_password_policy" "policy" {
      #     minimum_password_length        = 4
      #     require_lowercase_characters   = true
      #     require_numbers                = true
      #     allow_users_to_change_password = false
      #     max_password_age               = 7
      #   }
      #
      #   # good
      #   resource "aws_iam_account_password_policy" "policy" {
      #     minimum_password_length        = 20
      #     require_lowercase_characters   = true
      #     require_uppercase_characters   = true
      #     require_numbers                = true
      #     require_symbols                = true
      #     allow_users_to_change_password = true
      #   }
      class BadPasswordPolicy < Base
        register
        applies_to :aws_iam_account_password_policy

        def check
          check_length
          check_characters
          check_age
        end

        def check_length
          length = attributes['minimum_password_length']
          if length && length < 14
            offense('Set the minimum password length policy to at least 14.')
          end
        end

        def check_characters
          if !attributes['require_uppercase_characters'] ||
             !attributes['require_lowercase_characters']
            offense('Require both lowercase and uppercase characters.')
          end

          unless attributes['require_numbers']
            offense('Require numbers in passwords.')
          end

          unless attributes['require_symbols']
            offense('Require symbols in passwords.')
          end
        end

        def check_age
          age = attributes['max_password_age']
          if age && age < 90
            offense('Expiring passwords is discouraged. If you really have ' \
                    'to, do not do it more than once every 3 months.')
          end
        end
      end
    end
  end
end
