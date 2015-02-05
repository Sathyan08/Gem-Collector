require_relative 'collector'

class TestClass

  include Collector

  attr_accessor :age

  def initialize
    @happy = true
    @sad = false
    @age = rand(20..30)
    collections_check
  end

end
