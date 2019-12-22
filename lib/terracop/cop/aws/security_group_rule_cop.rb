# frozen_string_literal: true

require 'terracop/cop/base'

module Terracop
  module Cop
    module Aws
      # Base class that provides helper methods for other Cops checking
      # Security Group rules.
      class SecurityGroupRuleCop < Base
        applies_to :aws_security_group_rule

        protected

        def ingress?
          attributes['type'] == 'ingress'
        end

        def egress?
          attributes['type'] == 'egress'
        end

        def any_ip?
          attributes['cidr_blocks'].include?('0.0.0.0/0')
        end

        def tcp?
          attributes['protocol'] == 'tcp'
        end

        def udp?
          attributes['protocol'] == 'udp'
        end

        def port?(port)
          (attributes['from_port']..attributes['to_port']).include?(port)
        end

        def any_port?
          (attributes['from_port']..attributes['to_port']).count == 65_536
        end
      end
    end
  end
end
