# frozen_string_literal: true

module Getonbrd
  module APIOperations
    module Request
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def request(method, url, params = {})
          raise "Not supported method" \
            unless %i[get post put delete].include?(method)

          Util.debug "#{name} #{method.upcase} /#{url} ?q=#{params}"

          multipart = %i[post put].include?(method)
          response = api_client(multipart).send(method) do |req|
            req.url url
            req.body = multipart ? params : params.to_json
          end
          Util.serialize_response(response)
        end

        def api_client(multipart = false)
          @api_client = Faraday.new(url: BASE_URL) do |conn|
            if multipart
              conn.request :multipart
              conn.headers["Content-Type"] = "multipart/form-data"
            else
              conn.headers["Content-Type"] = "application/json"
            end
            conn.authorization(:Bearer, Getonbrd.api_key) if Getonbrd.api_key
          end
        end
      end

      protected def request(method, url, params = {})
        self.class.request(method, url, params)
      end
    end
  end
end
