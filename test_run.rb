require_relative 'test_class'
require 'pry'

me = TestClass.new
you = TestClass.new

instance_variables = me.instance_variables

binding.pry
