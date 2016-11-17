require 'date'
require 'csv'
require_relative 'Utilities.rb'

class PostData

  attr_accessor :filter_array
  attr_accessor :comment_map
  attr_accessor :comment_score
  attr_accessor :reply_arr


  def initialize(folder, filter=nil, start_date=nil, end_date=nil)
    unless start_date.nil? || end_date.nil?
      start_date = Date.parse(options.start_date)
      end_date = Date.parse(options.end_date)
    else
      start_date = Date.parse("20161010")
      end_date = Date.parse(Time.now.to_s)
    end

    @filter_array = nil

    @comment_map = {}
    @comment_score = {}
    @reply_arr = []

    #Generate a list of dates
    date_list = []
    for next_date in (start_date..end_date)
      date_list << "#{next_date.strftime('%Y%m%d')}"
    end

    unless filter.nil?
      @filter_array = []
      filter_file = File.open(filter)
      filter_file.each do |line|
        @filter_array.push(line.strip)
      end
    end

    i = date_list.size.to_f - 2
    for date in date_list
      begin
        reply_csv = CSV.open("#{folder}/Reply_#{date}.txt")
        comment_csv = File.open("#{folder}/Comment_#{date}.txt")
      rescue Exception
        return
      end

      comment_csv.each do |line|
        increment_map(@comment_map, line.strip, 0)
        increment_map(@comment_score, line.strip, i)
      end

      reply_csv.each do |row|
        @reply_arr << [row[0],row[1]]
      end

      i -= 1
    end
  end
end

