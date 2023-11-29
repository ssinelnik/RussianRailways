module Acсessors
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def my_attr_accessor(*names) # метод, в котором будут реализованы методы get и set
      names.each do |name|
        var_name = "@#{name}".to_sym # создать instance переменную, чтобы добавить имя к объекту
        define_method(name) { instance_variable_get(var_name)  } # get: получить значение instance переменной, передаём в параметр var_name

        define_method("#{name}=".to_sym) do |value| 
          if instance_variable_defined?("@#{name}_history")
            old_value = instance_variable_get(var_name)  
            instance_variable_get("@#{name}_history") << old_value
          else
            instance_variable_set("@#{name}_history", [])
          end
          instance_variable_set(var_name, value)
        end

        define_method("#{name}_history".to_sym) { instance_variable_get("@#{name}_history") }
    end
  end

    def force_attr_accessors(name, name_class)
      var_name = "@#{name}".to_sym
      class_name.capitalize!
      define_method(name) { instance_variable_get(var_name) }

      define_method("@#{name}=") do |value|
        raise TypeError.new("Invalid type of visible value!") unless value.is_a?(class_name)
        instance_variable_set(var_namem value)
      rescue TypeError => e
        puts e
        retry
      end  
    end
  end
end
