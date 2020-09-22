# frozen_string_literal: true

module Getonbrd
  module Util
    def self.serialize_response(response, symbolize_names: true)
      rjson = JSON.parse(response.body, symbolize_names: symbolize_names)
      return rjson if response.success?

      raise_error(response.status, rjson)
    end

    def self.raise_error(status, response)
      case status
      when 404
        raise NotFoundError.new(response.dig(:error), status)
      when 401
        raise AuthenticationError.new(response.dig(:error), status)
      when 422
        raise InvalidRequest.new(response.dig(:error), status)
      else
        raise UnkownAPIError.new(response.dig(:error), status)
      end
    end

    def self.debug(message)
      Getonbrd.logger&.debug(message)
    end
  end
end
