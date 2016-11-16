class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end
tv = Television.new
tv.manufacturer # The is would throw a no method error on manafacturer since it is a class method and not a instance method
tv.model # This would successfully call the model method from the Television class.

Television.manufacturer #This would succesfully call the method self.manafacturer from the Television class
Television.model # The is would throw a no method error on model since it is an instance method and not a class method
