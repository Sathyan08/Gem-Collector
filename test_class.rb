require_relative 'collector'

class TestClass

  include Collector

  attr_accessor :age

  def initialize
    @happy = true
    @sad = false
    @age = rand(25..26)

    collect_as_made
    consider_method(:hi)
  end

  def hi
    "hi"
  end

end
