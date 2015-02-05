require_relative 'test_class'
require 'pry'

me = TestClass.new
you = TestClass.new

TestClass.make_collections

c = TestClass.collections

binding.pry
