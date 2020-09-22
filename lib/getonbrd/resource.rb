# frozen_string_literal: true

module Getonbrd
  class Resource
    include APIOperations::Request
    extend  APIOperations::Create
    include APIOperations::Update
    include APIOperations::Delete

    class << self
      attr_accessor :resources_url, :expandable_classes
    end

    def self.class_name
      name.split("::")[-1]
    end

    def self.resource_url
      if self == Resource
        raise NotImplementedError,
              "Getonbrd::Resource is an abstract class. You should perform actions " \
              "on its subclasses (Organization, Person, Deal, etc)"
      end
      resources_url || "#{class_name.downcase}s"
    end

    def self.retrieve(id, params = {})
      response = request(:get, "#{resource_url}/#{id}", params)
      new(response.dig(:data))
    end

    def self.all(params = {})
      response = request(:get, resource_url, params)
      response.dig(:data)&.map { |d| new(d) }
    end

    def self.has_many(resource_name, class_name:)
      unless resource_name && class_name
        raise "You must specify the resource name and its class name " \
              "For example has_many :deals, class_name: 'Deal'"
      end
      class_name = "::Getonbrd::#{class_name}" unless class_name.include?("Getonbrd")
      define_method(resource_name) do |params = {}|
        response = request(:get, "#{resource_url}/#{resource_name}", params)
        response.dig(:data)&.map { |d| Object.const_get(class_name).new(d) }
      end
    end

    def initialize(data = {})
      @data = @unsaved_data = {}
      initialize_from_data(data)
    end

    def resource_url
      "#{self.class.resource_url}/#{id}"
    end

    def update_attributes(new_attrs)
      new_attrs.delete("id")
      @data.merge!(new_attrs)
    end

    def refresh
      response = request(:get, resource_url)
      initialize_from_data(response.dig(:data))
    end

    def initialize_from_data(data)
      # extract attributes
      attributes = data.delete(:attributes)
      # init data
      data.merge!(attributes) if attributes
      @data = data
      # define the methods for data and attributes
      @data.each_key do |key|
        klass = self.class
        if key == :method
          # Object#method is a built-in Ruby method that accepts a symbol
          # and returns the corresponding Method object. Because the API may
          # also use `method` as a field name, we check the arity of *args
          # to decide whether to act as a getter or call the parent method.
          klass.define_method(key) do |*args|
            args.empty? ? key : super(*args)
          end
        else
          @data[key] = resolve_expand(key)
          klass.define_method(key) { @data[key] }
        end

        klass.define_method(:"#{key}=") do |value|
          @data[key] = @unsaved_data[key] = value
        end

        next unless [FalseClass, TrueClass].include?(@data[key].class)

        klass.define_method(:"#{key}?") { @data[key] }
      end

      self
    end

    def resolve_expand(key)
      obj = @data[key]
      return obj unless obj.is_a?(Hash) && obj.key?(:data)

      new_inst = lambda do |data|
        e_class = self.class.expandable_classes[data[:type].to_sym]
        return data unless e_class

        e_class = "Getonbrd::#{e_class}" unless e_class.start_with?("Getonbrd")
        Object.const_get(e_class).new(data)
      end

      data = obj[:data]
      case data
      when Array
        data.map { |d| new_inst.call(d) }
      when Hash
        new_inst.call(data)
      else
        data
      end
    end
  end
end
