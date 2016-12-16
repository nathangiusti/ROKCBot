require 'clipboard'

HALF_LIFE = 14.0

#To increment by 1, just pass 0 for age. 1/2^(0/HALF_LIFE) == 1/2^0 == 1/1 == 1
def increment_map(map, key, age)
  if map.key?(key)
    map[key] = map[key]+1/2**(age/HALF_LIFE)
  else
    map[key] = 1/2**(age/HALF_LIFE)
  end
end

def map_to_sorted_arr(map)
  arr = map.sort_by { |k, v| v }
  arr.reverse!
end

def extract_from_arr(arr)
  return_arr = []
  arr.each do |k,v|
    return_arr << k
  end
  return_arr
end

def copy_to_clipboard(str)
  Clipboard.copy str
end

def find_max_rating(cj_filter, pd)
  max_val = 0
  i = 0
  str = ""
  cj_filter.each do |user_name|
    print "#{i}%\r"
    t_crushes = TrueCrushes.new(pd, user_name)
    if t_crushes.top_rating > max_val
      max_val =  t_crushes.top_rating
      str = t_crushes.top_rating_string
    end
    i += 1
  end
  puts "Max Val: #{max_val}\n"
  puts str
  max_val
end



