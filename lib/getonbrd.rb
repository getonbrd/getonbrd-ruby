# frozen_string_literal: true

require "logger"
require "faraday"
require "json"

# Version
require "getonbrd/version"

# API operations
require "getonbrd/api_operations/request"
require "getonbrd/api_operations/create"
require "getonbrd/api_operations/update"
require "getonbrd/api_operations/delete"

# Support classes
require "getonbrd/resource"
require "getonbrd/errors"
require "getonbrd/util"

# Named API Resources
require "getonbrd/resources"

module Getonbrd
  BASE_URL = "https://www.getonbrd.com/api/v0"

  class << self
    attr_accessor :api_key, :logger
  end

  @logger = Logger.new(STDOUT)
end
