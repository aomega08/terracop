# frozen_string_literal: true

require 'terracop/cop/base'

module Terracop
  module Cop
    module Aws
      # This cop makes sure that AWS resources that can be tagged, are indeed
      # tagged.
      # By default it just checks that resources have at least one tag, any tag.
      # It is configurable to enforce the existance of some specific tags.
      #
      # @example
      #   # bad
      #   resource "aws_alb" "lb" {
      #     name_prefix = "app"
      #   }
      #
      #   # good
      #   resource "aws_alb" "lb" {
      #     name_prefix = "app"
      #     tags = {
      #       environment = "staging"
      #     }
      #   }
      class EnsureTags < Base
        register

        def check
          return unless attributes['tags']

          if self.class.config['Required']
            check_required(self.class.config['Required'])
          elsif attributes['tags'].empty?
            offense 'Tag resources properly.'
          end
        end

        private

        def check_required(required_tags)
          required_tags.each do |key|
            unless attributes['tags'][key]
              offense "Required tag \"#{key}\" is missing on this resource."
            end
          end
        end
      end
    end
  end
end
