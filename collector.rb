module Collector

  def self.included(base)
    base.extend(ClassMethods)
    base.instance_variable_set(:@collections, { })
  end

  def make_collections
    instance_variables.each { |variable| make_collection(variable)  }
    my_class.collections[:all] = { }
  end

  def make_collection(variable)
    my_class.collections[variable] = { }
  end

  def my_class
    self.class
  end

  def collections_check
    make_collections if !made_collections?
    consider_all
    my_class.collections[:all][object_id] = self
  end

  def made_collections?
    !my_class.collections.empty?
  end

  def consider_all
    instance_variables.each { |variable| consider(variable) }
  end

  def consider(variable)
    add_to_(variable) if instance_variable_get(variable).class == TrueClass
  end

  def add_to_(variable)
    my_class.collections[variable][object_id] = self
  end

  module ClassMethods
    attr_reader :collections
  end

end
