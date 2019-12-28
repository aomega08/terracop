# frozen_string_literal: true

require 'json'
require 'yaml'

require 'terracop/cop/aws/bad_password_policy'
require 'terracop/cop/aws/describe_security_group_rules'
require 'terracop/cop/aws/ensure_propagated_tags'
require 'terracop/cop/aws/ensure_tags'
require 'terracop/cop/aws/fault_intolerant'
require 'terracop/cop/aws/iam_inline_policy'
require 'terracop/cop/aws/iam_policy_attachment'
require 'terracop/cop/aws/open_egress'
require 'terracop/cop/aws/open_ingress'
require 'terracop/cop/aws/open_ssh'
require 'terracop/cop/aws/prefer_launch_templates'
require 'terracop/cop/aws/unrestricted_egress_ports'
require 'terracop/cop/aws/unrestricted_ingress_ports'
require 'terracop/cop/aws/wide_egress'
require 'terracop/cop/aws/wide_ingress'

require 'terracop/cop/style/dash_in_resource_name'
require 'terracop/cop/style/resource_type_in_name'
require 'terracop/cop/style/snake_case'

require 'terracop/formatters/default'
require 'terracop/formatters/html'
require 'terracop/formatters/json'

require 'terracop/plan_loader'
require 'terracop/runner'
require 'terracop/state_loader'
require 'terracop/version'

# Wrapper module for the gem.
module Terracop
  class Error < StandardError; end

  class << self
    def config
      @config ||= begin
        defaults_path = File.join(__dir__, '../default_config.yml')
        overrides_path = '.terracop.yml'

        config = YAML.safe_load(File.read(defaults_path)) || {}
        if File.exist?(overrides_path)
          config.merge!(YAML.safe_load(File.read(overrides_path)) || {})
        end

        config
      end
    end
  end
end
