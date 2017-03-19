require 'date'
require 'csv'
require_relative 'Utilities.rb'

class PostData

  attr_accessor :comment_arr
  attr_accessor :reply_arr


  def initialize(folder, cj_filter=nil, start_date=nil, end_date=nil)
    @filter_array = cj_filter

    unless start_date.nil? || end_date.nil?
      start_date = Date.parse(options.start_date)
      end_date = Date.parse(options.end_date)
    else
      start_date = Date.parse("20170221")
      end_date = Date.parse(Time.now.to_s)
    end

    @comment_arr = []
    @reply_arr = []

    #Generate a list of dates
    date_list = []
    for next_date in (start_date..end_date)
      date_list << "#{next_date.strftime('%Y%m%d')}"
    end

    i = date_list.size.to_f - 2
    for date in date_list
      begin
        reply_csv = CSV.open("#{folder}/Reply_#{date}.txt")
        comment_csv = File.open("#{folder}/Comment_#{date}.txt")
      rescue Exception
        return
      end

      temp_arr = []
      comment_csv.each do |row|
        if is_not_filtered?(row)
          temp_arr << row
        end
      end
      @comment_arr << temp_arr


      temp_arr = []
      reply_csv.each do |row|

        #Get rid of users replying to themselves
        if row[0] == row[1]
          next
        end
        if is_not_filtered?(row[0]) && is_not_filtered?(row[1])
          temp_arr << [row[0],row[1]]
        end
      end
      @reply_arr << temp_arr

      i -= 1
    end
  end

  def is_not_filtered?(val)
    return (@filter_array.nil? || @filter_array.include?(val))
  end
end

