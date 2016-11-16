class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information #instead of self.light_information
    "I want to turn on the light with a brightness level of super high and a colour of green"
  end

end

# We do that because when calling the method with an instance of the class it becomes repetitive.
