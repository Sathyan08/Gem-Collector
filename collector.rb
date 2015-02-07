module Collector

  def self.included(base)
    base.extend(ClassMethods)
    base.instance_variable_set(:@collections, { })
  end

  def my_class
    self.class
  end

  def add_to_all
    my_class.collections[:all] = { } if !my_class.collections.has_key?(:all)
    my_class.collections[:all][object_id] = self
  end

  def collect_as_made
    add_to_all
    consider_all
  end

  def consider_all
    instance_variables.each { |variable| consider(variable) }
  end

  def consider(variable)
    my_class.collections.has_key?(variable) ? check_value(variable) : make_collection(variable)
  end

  def consider_method(method)
    my_class.collections.has_key?(method) ? check_method(method) : make_method_collection(method)
  end

  def make_collection(variable)
    my_class.collections[variable] = { }
    check_value(variable)
  end

  def make_method_collection(method)
    my_class.collections[method] = { }
    check_method(method)
  end

  def check_method(method)
    value = send(method)
    key_check(method, value)
  end

  def check_value(variable)
    value = instance_variable_get(variable)
    value_key = keyify(value)
    if my_class.collections[variable].has_key?(value_key)
      my_class.collections[variable][value_key][object_id] = self
    else
      my_class.collections[variable][value_key] = { }
      my_class.collections[variable][value_key][object_id] = self
    end
  end

  def key_check(method_or_var, value)
    value_key = keyify(value)
    if my_class.collections[method_or_var].has_key?(value_key)
      my_class.collections[method_or_var][value_key][object_id] = self
    else
      my_class.collections[method_or_var][value_key] = { }
      my_class.collections[method_or_var][value_key][object_id] = self
    end
  end

  def keyify(value)
    value.to_s.to_sym
  end

  module ClassMethods
    attr_reader :collections

    def keyify(value)
      value.to_s.to_sym
    end

    def all_collection
      collections[:all]
    end

    def all_instances
      collections[:all].values
    end

    def make_collections
      collections[:all].each_value { |instance| instance.consider_all }
    end

    def reset_collections
      all_inst = self.all_instances
      collections.clear
      all_inst.each {|instance| instance.collect_as_made } if all_inst
    end

    def possible_values_as_keys(variable)
      collections[variable].keys
    end

    def possible_values(variable)
      possible_values_as_keys(variable).map { |value| eval(value.to_s) }
    end

    def equal_to(variable, value)
      key = keyify(value)
      collections[variable][key].values
    end

    def most_common_value(variable)
      options = collections[variable].sort_by { |variable, objects| objects.count }
      eval(options.last.first.to_s)
    end

    def with_most_common_value(variable)
      options = collections[variable].sort_by { |variable, objects| objects.count }
      options.last.last.values
    end

    def less_than_or_equal_to(variable, value)
      possibilities = possible_values(variable)
      new_values = possibilities.select { |possibility| possibility <= value }

      get_range(variable, new_values)
    end

    def less_than(variable, value)
      possibilities = possible_values(variable)
      new_values = possibilities.select { |possibility| possibility < value }

      get_range(variable, new_values)
    end

    def greater_than_or_equal_to(variable, value)
      possibilities = possible_values(variable)
      new_values = possibilities.select { |possibility| possibility >= value }

      get_range(variable, new_values)
    end

    def greater_than(variable, value)
      possibilities = possible_values(variable)
      new_values = possibilities.select { |possibility| possibility > value }

      get_range(variable, new_values)
    end

    def get_range(variable, new_values)
      results = new_values.inject({ }) do | memo , new_value|
        memo.merge(collections[variable][keyify(new_value)])
      end

      results.values
    end

  end

end
