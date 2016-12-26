require_relative 'PostData.rb'
require_relative 'Utilities.rb'

class TrueCrushes

  attr_accessor :normalize_max_fan_arr
  attr_accessor :normalize_max_crush_arr

  def initialize(post_data, user_name, max_rating=100)
    @user_name = user_name

    #Stores the total number of times a user was replied to
    @fan_comment_count = 0

    #Stores the total number of times a user replied to someone
    @crush_comment_count = 0

    #Stores the total number of times each user replied to someone
    bulk_fan_map = {};

    #Stores the total number of times each user was replied to
    bulk_crush_map = {};


    crush_map = {}
    fan_map = {}

    i = post_data.reply_arr.size - 2
    post_data.reply_arr.each do |arr|
      arr.each do |row|
        increment_map(bulk_fan_map, row[1], i)
        increment_map(bulk_crush_map, row[0], i)

        if row[0] == @user_name
          increment_map(fan_map, row[1], i)
          @fan_comment_count += 1
        elsif row[1] == @user_name
          increment_map(crush_map, row[0], i)
          @crush_comment_count += 1
        end
      end
      i -= 1
    end

    @max_fan_arr = map_to_sorted_arr(fan_map)
    @max_crush_arr = map_to_sorted_arr(crush_map)

    normalize_fan_map = {}
    normalize_crush_map = {}

    fan_map.each do |key, value|
      normalize_fan_map[key] = (value/bulk_fan_map[key])/max_rating * 10000
    end

    crush_map.each do |key, value|
      normalize_crush_map[key] = (value/bulk_crush_map[key])/max_rating * 10000
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
      #get_percentile
      ret_str << "\n#{obj[0].ljust(25)}: #{obj[1].round(1)}\n"
    end
    ret_str
  end

  def top_rating
    @normalize_max_fan_arr[0][1] > @normalize_max_crush_arr[0][1] ? @normalize_max_fan_arr[0][1] : @normalize_max_crush_arr[0][1]
  end

  def top_rating_string
    @normalize_max_fan_arr[0][1] > @normalize_max_crush_arr[0][1] ? "#{@normalize_max_fan_arr[0][0]} loves #{@user_name}" : "#{@user_name} loves #{@normalize_max_crush_arr[0][0]}"
  end

end


