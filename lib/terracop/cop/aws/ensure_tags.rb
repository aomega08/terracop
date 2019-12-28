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
          tags = tags_for(attributes)
          return unless tags

          if self.class.config['Required']
            check_required(tags, self.class.config['Required'])
          elsif tags.empty?
            offense 'Tag resources properly.'
          end
        end

        private

        def check_required(tags, required_tags)
          required_tags.each do |key|
            unless tag(tags, key)
              offense "Required tag \"#{key}\" is missing on this resource."
            end
          end
        end

        def tags_for(attributes)
          case type
          when 'aws_autoscaling_group'
            attributes['tags'] || attributes['tag']
          else
            attributes['tags']
          end
        end

        def tag(list, name)
          if list.is_a?(Hash)
            list[name]
          else
            list.find { |tag| tag['key'] == name }
          end
        end
      end
    end
  end
end
