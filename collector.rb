module Collector

  def self.included(base)
    base.extend(ClassMethods)
    base.instance_variable_set(:@collections, {})
  end

  def make_collections
    instance_variables = self.instance_variables
    instance_variables.each { |variable| my_class.collections[variable] = { } }
  end

  def my_class
    self.class
  end

  def collected?
    my_class.collected
  end

  def consider(variable)
    add_to_(variable) if instance_variable_get(variable).class == TrueClass
  end

  def add_to_(variable)
    my_class.collections[variable][object_id] = self
  end

  module ClassMethods
    attr_accessor :collections
  end

end
