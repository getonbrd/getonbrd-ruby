# frozen_string_literal: true

module Getonbrd
  module Public
    class Category < Resource
      self.resources_url = "categories"

      has_many :jobs, class_name: "Public::Job"
    end
  end
end
