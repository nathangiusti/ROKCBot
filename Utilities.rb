HALF_LIFE = 21.0

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
