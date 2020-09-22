# frozen_string_literal: true

module Getonbrd
  module Public
    class Search < Resource
      # GET /search/jobs?q=
      # Search for jobs
      def self.jobs(query, params = {})
        raise "Param search is required and must be at least three chars" \
              unless query && query.length >= 3

        response = request(:get, "search/jobs", params.merge(query: query))
        response.dig(:data)&.map { |d| Public::Job.new(d) }
      end
    end
  end
end
