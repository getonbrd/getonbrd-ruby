# frozen_string_literal: true

module Getonbrd
  class Error < StandardError
    attr_reader :code

    def initialize(message = nil, code = nil)
      super(message)
      @message = message
      @code = code
    end

    def message
      code_str = @code.nil? ? "" : "(Status #{@code}) "
      "#{code_str}#{@message}"
    end
  end
  class SettingError < Error; end
  class AuthenticationError < Error; end
  class NotFoundError < Error; end
  class InvalidRequest < Error; end
  class UnkownAPIError < Error; end
end
