require_relative 'test_class'
require 'pry'

objs = []

3.times { objs << TestClass.new }

TestClass.make_collections

c = TestClass.collections

binding.pry
