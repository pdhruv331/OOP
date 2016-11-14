class Cube
  attr_reader :volume
  def initialize(volume)
    @volume = volume
  end
end

cube = Cube.new("12 cubic meters")
puts cube.volume