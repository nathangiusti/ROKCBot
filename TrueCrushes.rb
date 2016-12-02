require_relative 'PostData.rb'
require_relative 'Utilities.rb'

class TrueCrushes

  def initialize(post_data, user_name, filter_array_param)

    @filter_array = filter_array_param
    @fan_comment_count = 0
    @crush_comment_count = 0

    comment_count = 0
    bulk_fan_map = {};
    bulk_crush_map = {};
    crush_map = {}
    fan_map = {}

    post_data.reply_arr.each do |arr|
      arr.each do |row|
        if is_not_filtered?(row[1]) && is_not_filtered?(row[0])
          increment_map(bulk_fan_map, row[1], 0)
          increment_map(bulk_crush_map, row[0], 0)
          if row[0] == user_name
            increment_map(fan_map, row[1], 0)
            @fan_comment_count += 1
          elsif row[1] == user_name
            increment_map(crush_map, row[0], 0)
            @crush_comment_count += 1
          end
        end
      end
    end

    @max_fan_arr = map_to_sorted_arr(fan_map)
    @max_crush_arr = map_to_sorted_arr(crush_map)

    normalize_fan_map = {}
    normalize_crush_map = {}

    fan_map.each do |key, value|
      normalize_fan_map[key] = fan_map[key]/bulk_fan_map[key] * 100
    end

    crush_map.each do |key, value|
      normalize_crush_map[key] = crush_map[key]/bulk_crush_map[key] * 100
    end

    @normalize_max_fan_arr = map_to_sorted_arr(normalize_fan_map)
    @normalize_max_crush_arr = map_to_sorted_arr(normalize_crush_map)
  end

  def get_user_info_string

    ret_str = "\n\\----------------------------------------------------\n\n"
    ret_str << "Your true fans\n"
    ret_str << get_arr_str(@normalize_max_fan_arr, 4)
    ret_str << "\n\\----------------------------------------------------\n\n"
    ret_str << "Your true crushes\n"
    ret_str << get_arr_str(@normalize_max_crush_arr, 4)
    ret_str << "\n"
  end

  def get_arr_str(array, limit)
    ret_str = ""
    if limit > array.length
      limit = array.length
    end
    array[0..limit].each do |obj|
      ret_str << "\n#{obj[0].ljust(25)}: #{obj[1].round(0)}\n"
    end
    ret_str
  end

  def is_not_filtered?(val)
    return (@filter_array.nil? || @filter_array.include?(val))
  end

end


