require_relative 'collector'

class TestClass

  include Collector

  attr_accessor :age

  def initialize
    @happy = true
    @sad = false
    @age = 25
    # @age = rand(20..30)

    collect_as_made
  end

end
