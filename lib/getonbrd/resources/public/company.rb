# frozen_string_literal: true

module Getonbrd
  module Public
    class Company < Resource
      self.resources_url = "companies"

      has_many :jobs, class_name: "Public::Job"
    end
  end
end
