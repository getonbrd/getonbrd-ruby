# frozen_string_literal: true

module Getonbrd
  module Private
    class Process < Resource
      self.resources_url = "processes"
      self.expandable_classes = {
        job: "Private::Job",
        phase: "Private::Phase",
      }

      def applications(params = {})
        @applications ||= Private::Application.all(params.merge(process_id: id))
      end

      def professionals(params = {})
        @professionals ||= Private::Professional.all(params.merge(process_id: id))
      end
    end
  end
end
