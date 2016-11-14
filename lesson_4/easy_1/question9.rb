class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# The self.cats_count is a class method. So self is referring to the  class itself.
# You can call this method directly on the class

