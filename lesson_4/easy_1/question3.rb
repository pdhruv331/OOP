module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed
  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed
  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end
camry = Car.new
ford = Truck.new
camry.go_fast
ford.go_fast

# The self.class is used to include the type of vehicle in the string output in go_fast.
# The self lets us know what object we are dealing with. In this scenario either camry or ford.
# We then call .class on that object. So camry.class returns Car and ford.class returns Truck