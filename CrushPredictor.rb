require_relative 'PostData.rb'
require_relative 'PostCount.rb'
require_relative 'Crushes.rb'
require_relative 'TrueCrushes.rb'
require_relative 'Utilities.rb'

def combine_arrays(crushes, un_arr)
  crush_map = {}

  crushes.each do |crush|
    crush.max_crush_arr.each do |key, value|
      if crush_map.key?(key)
        crush_map[key] = crush_map[key]+value
      else
        crush_map[key] = value
      end
    end
  end

  un_arr.each do |un|
    if crush_map.key?(un)
      crush_map[un] = -1
    end
  end

  map_to_sorted_arr(crush_map)
end

puts "Building database"
pd = PostData.new("heroku")
pc = PostCount.new(pd)

while true
  error = false
  print " > "
  line = gets
  un_arr = line.split(' ')

  un_arr.each do |un|

    un.sub! '/u/', ''

    unless pc.does_user_exist un
      puts "No such user #{un}"
      error = true
    end
  end

  if error
    next
  end

  crushes = []
  un_arr.each do |un|
    crushes << Crushes.new(pd, un)
  end

  array = combine_arrays(crushes, un_arr)

  ret_str = ""

  array[0..2].each do |obj|
    ret_str << "\n/u/#{obj[0].ljust(25)}\n"
  end

  copy_to_clipboard(ret_str)
  puts ret_str

end
