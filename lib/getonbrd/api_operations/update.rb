# frozen_string_literal: true

module Getonbrd
  module APIOperations
    module Update
      def update(params)
        response = request(:put, resource_url, params)
        update_attributes(response.dig(:data))
      end
    end
  end
end
