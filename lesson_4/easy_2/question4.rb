class BeesWax
  attr_accessor :type
  def initialize(type)
    @type = type
  end

  # def type
  #   @type     
  # end

  # def type=(t)
  #   @type = t
  # end

  def describe_type
    puts "I am a #{type} of Bees Wax"
  end
end

# The two methods commented out above were getter and setter methods. 
# ruby has a way of creating getters and setters for you by using attr_accessor  