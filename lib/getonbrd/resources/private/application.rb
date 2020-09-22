# frozen_string_literal: true

module Getonbrd
  module Private
    class Application < Resource
      self.expandable_classes = {
        job: "Private::Job",
        phase: "Private::Phase",
        professional: "Private::Professional",
        answers: "Private::Answer",
        message: "Private::Message",
        note: "Private::Note",
      }
    end
  end
end
