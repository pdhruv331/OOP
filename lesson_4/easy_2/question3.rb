module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end


# Orange.ancestors and HotSauce.ancestors will tell you its look up path