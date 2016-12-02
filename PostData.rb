require 'date'
require 'csv'
require_relative 'Utilities.rb'

class PostData

  attr_accessor :comment_arr
  attr_accessor :reply_arr


  def initialize(folder, start_date=nil, end_date=nil)
    unless start_date.nil? || end_date.nil?
      start_date = Date.parse(options.start_date)
      end_date = Date.parse(options.end_date)
    else
      start_date = Date.parse("20161010")
      end_date = Date.parse(Time.now.to_s)
    end

    @filter_array = nil

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
        temp_arr << row
      end
      @comment_arr << temp_arr


      temp_arr = []
      reply_csv.each do |row|
        temp_arr << [row[0],row[1]]
      end
      @reply_arr << temp_arr

      i -= 1
    end
  end
end

