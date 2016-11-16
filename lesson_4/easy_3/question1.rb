class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

#case 1
hello = Hello.new
hello.hi
# This will print 'Hello' to the terminal

#case 2
hello = Hello.new
hello.bye
# This will throw a undefined method error. The Hello class or the Greeting class dont have a method called bye.
#case3
hello = Hello.new
hello.greet
# This throws an argument error because the greet method that is accessible by Greeting's subclass hello requires one argument to be passed in.

#case 4
hello = Hello.new
hello.greet("Goodbye")
# This will print 'Goodbye' to the terminal

#case 5
Hello.hi
# This will throw an No method error on hi. this happens cause hi is not a class method it is an instance method.