# frozen_string_literal: true

module Getonbrd
  module APIOperations
    module Create
      def create(params)
        response = request(:post, resource_url, params)
        new(response.dig(:data))
      end
    end
  end
end
