module Collector

  def self.included(base)
    base.extend(ClassMethods)
  end

  def make_collections
    instance_variables = self.instance_variables

    my_class = self.class
    my_class.instance_variable_set(:@collections, { })

    instance_variables.each { |variable| my_class.collections[variable] = { }  }

    # instance_variables.each {|variable| my_class.instance_variable_get(:@collections).[variable] = { } }
  end

  module ClassMethods
    def collections
      @collections
    end
  end

end
