# frozen_string_literal: true

module Getonbrd
  module Private
    class Job < Resource
      self.expandable_classes = {
        tag: "Public::Tag",
        company: "Public::Company",
        question: "Private::Question",
      }
    end
  end
end
