require_relative 'PostData.rb'
require_relative 'Utilities.rb'

class Crushes

  def initialize(post_data, user_name)

    @fan_comment_count = 0
    @crush_comment_count = 0

    comment_count = 0
    bulk_fan_map = {};
    bulk_crush_map = {};
    crush_map = {}
    fan_map = {}

    post_data.reply_arr.each do |arr|
      arr.each do |row|

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

    stalker_map = {}
    fan_map.each do |key, value|
      if crush_map.key?(key) && fan_map[key] > crush_map[key]
        stalker_map[key] = fan_map[key] - crush_map[key]
      end
    end

    stalkee_map = {}
    crush_map.each do |key, value|
      if fan_map.key?(key) && crush_map[key] > fan_map[key]
        stalkee_map[key] = crush_map[key] - fan_map[key]
      end
    end

    @max_stalkee_arr = map_to_sorted_arr(stalkee_map)
    @max_stalker_arr = map_to_sorted_arr(stalker_map)
    @max_fan_arr = map_to_sorted_arr(fan_map)
    @max_crush_arr = map_to_sorted_arr(crush_map)
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

  def get_user_info_string
    ret_str = "\n\\----------------------------------------------------\n\n"
    ret_str << "#{@max_fan_arr.length} fans in #{@fan_comment_count} comments\n"
    ret_str << get_arr_str(@max_fan_arr, 4)
    ret_str << "\n\\----------------------------------------------------\n\n"
    ret_str << "#{@max_crush_arr.length} crushes in #{@crush_comment_count} comments\n"
    ret_str << get_arr_str(@max_crush_arr, 4)
    ret_str << "\n\\----------------------------------------------------\n\n"
    ret_str << "Stalks #{@max_stalkee_arr.length} people\n"
    ret_str << get_arr_str(@max_stalkee_arr, 4)
    ret_str << "\n\\----------------------------------------------------\n\n"
    ret_str << "Stalked by #{@max_stalker_arr.length} people\n"
    ret_str << get_arr_str(@max_stalker_arr, 4)
  end
end
