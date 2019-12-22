# frozen_string_literal: true

require 'json'
require 'yaml'

require 'terracop/cop/aws/describe_security_group_rules'
require 'terracop/cop/aws/ensure_tags'
require 'terracop/cop/aws/iam_role_policy'
require 'terracop/cop/aws/open_egress'
require 'terracop/cop/aws/open_ingress'
require 'terracop/cop/aws/open_ssh'
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

require 'terracop/runner'
require 'terracop/version'

# Wrapper module for the gem.
module Terracop
  class Error < StandardError; end

  class << self
    def config
      defaults_path = File.join(__dir__, '../default_config.yml')
      @config ||= YAML.safe_load(File.read(defaults_path))
    end
  end
end
