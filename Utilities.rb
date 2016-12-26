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
  crush_val_arr = []
  i = 0
  str = ""
  cj_filter.each do |user_name|
    print "#{i}%\r"
    t_crushes = TrueCrushes.new(pd, user_name)
    if t_crushes.top_rating > max_val
      max_val =  t_crushes.top_rating
      str = t_crushes.top_rating_string
    end
    t_crushes.normalize_max_fan_arr[0..4].each do |val|
      crush_val_arr << val[1]
    end
    t_crushes.normalize_max_crush_arr[0..4].each do |val|
      crush_val_arr << val[1]
    end
    i += 1
  end
  puts "Max Val: #{max_val}\n"
  puts str
  crush_val_arr.each do |val|
    val = val/max_val * 10000
  end
  crush_val_arr.sort!
end

def get_percentile(num, val_arr)
  i = 0
  val_arr.each do |val|
    i += 1
    if num < val
      return i/val_arr.length
    end
  end
  -1
end





