module Collector

  def make_collections
    instance_variables = self.instance_variables
    my_class = self.class

    instance_variables.each do |variable|
      my_class.instance_variable_set(variable, { })
    end
  end

end
