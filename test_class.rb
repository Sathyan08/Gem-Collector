require_relative 'collector'

class TestClass

  include Collector

  attr_accessor :age

  def initialize
    @happy = true
    @age = 18
    collections_check
  end

end
