require_relative 'Utilities.rb'
require_relative 'PostData.rb'

class PostCount

  attr_accessor :post_count_map
  attr_accessor :post_score_map
  attr_accessor :post_count_arr
  attr_accessor :post_score_arr

  def initialize(post_data)
    @post_count_map = {}
    @post_score_map = {}
    @post_count_arr = {}
    @post_score_arr = {}

    i = post_data.comment_arr.size - 2

    post_data.comment_arr.each do |arr|
      arr.each do |line|
        line.strip!
        increment_map(@post_count_map, line, 0)
        increment_map(@post_score_map, line, i)
      end
      i -= 1
    end

    post_data.reply_arr.each do |arr|
      arr.each do |row|
        increment_map(@post_score_map, row[0], i)
      end
      i -= 1
    end

    @post_score_arr = extract_from_arr(map_to_sorted_arr(post_score_map))
    @post_count_arr = extract_from_arr(map_to_sorted_arr(post_count_map))
  end

  def get_filter(limit)
    @post_score_arr[0..limit]
  end

  def get_user_count_number(username)
    if @post_count_map.key?(username)
      @post_count_map[username]
    else
      0
    end
  end

  def get_user_score_number(username)
    if @post_score_map.key?(username)
      @post_score_map[username]
    else
      0
    end
  end

  def get_user_count_rank(username)
    @post_count_arr.find_index(username) + 1
  end

  def get_user_score_rank(username)
    @post_score_arr.find_index(username) + 1
  end

  def get_user_info_map(username)
    return_map = {}
    return_map[:count_number] = get_user_count_number(username)
    return_map[:score_number] = get_user_score_number(username)
    return_map[:count_rank] = get_user_count_rank(username)
    return_map[:score_rank] = get_user_score_rank(username)
    return_map
  end

  def get_user_info_string(username)
    info = get_user_info_map(username)
    ret_str = "#{username}\n\n"
    ret_str << "Comment Count: #{info[:count_number].round(0)} (Rank #{info[:count_rank]})\n\n"
    ret_str << "CJ Score: #{info[:score_number].round(0)} (Rank #{info[:score_rank]})\n\n"
    ret_str
  end

  def get_simple_user_info_string(username)
    info = get_user_info_map(username)
    "#{info[:score_rank]}\t #{username.ljust(25)}: #{info[:score_number].round(0)}"
  end

  def does_user_exist(username)
    @post_count_map.key?(username)
  end

  def get_total_number_comments
    sum = 0
    post_count_map.each do |key,val|
      sum += val
    end
    sum
  end

  def get_total_number_users
    post_count_arr.length
  end

  def get_total_score(limit=-1)
    sum = 0
    map_to_sorted_arr(post_score_map)[0..limit].each do |val|
      sum += val[1]
    end
    sum
  end
end

