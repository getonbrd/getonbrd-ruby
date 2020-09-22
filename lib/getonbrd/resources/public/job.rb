# frozen_string_literal: true

module Getonbrd
  module Public
    class Job < Resource
      self.expandable_classes = {
        tag: "Public::Tag",
        company: "Public::Company",
      }
    end
  end
end
