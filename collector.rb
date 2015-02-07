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

  def make_collection(variable)
    my_class.collections[variable] = { }
    check_value(variable)
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
      all_inst.each {|instance| instance.collect_as_made }
    end

    def possible_values_as_keys(variable)
      collections[variable].keys
    end

    def possible_values(variable)
      keys = possible_values_as_keys(variable)
      values = [ ]

      keys.each do |value|
        values << collections[variable][value].values.first.instance_variable_get(variable)
      end

      values
    end

    def equal_to(variable, value)
      key = keyify(value)
      collections[variable][key].values
    end

    def most_common_value(variable)
      options = collections[variable].sort_by { |variable, objects| objects.count }
      options.last.values.first.instance_variable_get(variable)
    end

    def less_than_or_equal_to(variable, value)
      possibilities = possible_values(variable)
      new_values = possibilities.select { |possibility| possibility <= value }

      results = new_values.inject({ }) do | memo , new_value|
        memo.merge(collections[variable][keyify(new_value)])
      end

      results.values
    end

    def less_than(variable, value)
      possibilities = possible_values(variable)
      new_values = possibilities.select { |possibility| possibility < value }

      results = new_values.inject({ }) do | memo , new_value|
        memo.merge(collections[variable][keyify(new_value)])
      end

      results.values
    end

    def greater_than_or_equal_to(variable, value)
      possibilities = possible_values(variable)
      new_values = possibilities.select { |possibility| possibility >= value }

      results = new_values.inject({ }) do | memo , new_value|
        memo.merge(collections[variable][keyify(new_value)])
      end

      results.values
    end

    def greater_than(variable, value)
      possibilities = possible_values(variable)
      new_values = possibilities.select { |possibility| possibility > value }

      results = new_values.inject({ }) do | memo , new_value|
        memo.merge(collections[variable][keyify(new_value)])
      end

      results.values
    end

  end

end
