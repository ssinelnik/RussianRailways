# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(name, type, *param)
      @validate ||= []
      @validate << { name: name, type: type, param: param }
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    private

    def validate!
      self.class.instance_variable_get("@validate").each do |hash|
        name = hash[:name]
        value = instance_variable_get("@#{name}")
        type = hash[:type]
        param = hash[:param][0]
        send("validate_#{type}", name, value, param)
      end
    end

    def validate_presence(name, value, _) # validate_presence - требует, чтобы значение атрибута было не nil и не пустой строкой
      raise "#{name} must be real!" if value.nil? || value.to_s.empty?
    end

    def validate_format(name, value, regular_expression) #  validate_format - треубет соответствия значения атрибута заданному регулярному выражению, т.е. regular_expression
      raise "#{name} must be #{regular_expression}!" if value !~ regular_expression
    end

    def validate_type(name, value, type) # validate_type - требует соответствия значения атрибута заданному классу
      raise "Type #{name} must be #{type}" unless value.is_a?(type)
    end

    def validate_positive(name, value, _) # validate_positive - требует, чтобы значение не было пустым
      raise "#{name} should be positive" unless value.positive?
    end

    def validate_length(name, value, param) # validate_length - требует, чтобы значение было определённой длины
      raise "Length of #{name} should be at least #{param}" if value.length < param
    end
  end
end
