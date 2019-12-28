# frozen_string_literal: true

require 'terracop/cop/base'

module Terracop
  module Cop
    module Aws
      # This cop makes sure that EC2 instances launched by Autoscaling Groups
      # also have tags. It is configured like the Aws/EnsureTags cop.
      #
      # @example
      #   # bad
      #   resource "aws_asg" "asg" {
      #     tag {
      #       key = "Name"
      #       value = "asg"
      #       propagate_at_launch = false
      #     }
      #   }
      #
      #   # good
      #   resource "aws_asg" "asg" {
      #     tag {
      #       key = "Name"
      #       value = "asg"
      #       propagate_at_launch = true
      #     }
      #   }
      class EnsurePropagatedTags < Base
        register
        applies_to :aws_autoscaling_group

        def check
          if self.class.config['Required']
            check_required(propagated_tags, self.class.config['Required'])
          elsif propagated_tags.empty?
            offense 'The EC2 instances launched by this Autoscaling group ' \
                    'will not have any tags.'
          end
        end

        private

        def propagated_tags
          tags = attributes['tags'] || attributes['tag']
          tags.select { |t| t['propagate_at_launch'] }
        end

        def check_required(tags, required_tags)
          required_tags.each do |key|
            unless tags.find { |t| t['key'] == key }
              offense "Required tag \"#{key}\" is not propagated to EC2 " \
                      'instances launched by this Autoscaling Group.'
            end
          end
        end
      end
    end
  end
end
