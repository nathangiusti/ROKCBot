require 'csv'
require 'date'
require 'optparse'
require 'ostruct'

def increment_map(map, value)
  if map.key?(value)
    map[value] = map[value]+1.0
  else
    map[value] = 1.0
  end
end

def is_not_filtered?(val)
  return (@@filter_array.nil? || @@filter_array.include?(val))
end

options = OpenStruct.new
ARGV << '-h' if ARGV.empty?

OptionParser.new do |opts|

  opts.banner = "Usage: CrushBotRawNumber.rb [options]"


  opts.on("--start_date start_date") do |v|
    options.start_date = v
  end

  opts.on("--end_date end_date") do |v|
    options.end_date = v
  end

  opts.on("-f filter_list", "--filter_list filter_list") do |v|
    options.filter_list = v
  end

  opts.on("-u user_name", "--user_name user_name") do |v|
    options.user_name = v
  end

  opts.on("-n", "--normalize") do |v|
    options.normalize = true
  end

end.parse!

start_date = Date.parse(options.start_date)
end_date = Date.parse(options.end_date)
@@filter_array = nil
ARCHIVE_DIR = "archive"

#Generate a list of dates
date_list = []
for next_date in (start_date..end_date)
  date_list << "#{next_date.strftime('%Y%m%d')}"
end


unless options.filter_list.nil?
  @@filter_array = []
  filter_file = File.open(options.filter_list)
  filter_file.each do |line|
    @@filter_array.push(line.strip)
  end
end

comment_count = 0
fan_comment_count = 0
crush_comment_count = 0
bulk_fan_map = {};
bulk_crush_map = {};
crush_map = {}
fan_map = {}

for date in date_list
  reply_csv = CSV.open("#{ARCHIVE_DIR}/Reply_#{date}.txt")
  comment_csv = File.open("#{ARCHIVE_DIR}/Comment_#{date}.txt")

  #Get number of comments by user
  comment_csv.each do |line|
    if line.strip == options.user_name
      comment_count += 1
    end
  end


  reply_csv.each do |row|

    if is_not_filtered?(row[1]) && is_not_filtered?(row[0])
      increment_map(bulk_fan_map, row[1])
      increment_map(bulk_crush_map, row[0])
    end

    if row[0] == options.user_name && is_not_filtered?(row[1])
      increment_map(fan_map, row[1])
      fan_comment_count += 1
    elsif row[1] == options.user_name && is_not_filtered?(row[0])
      increment_map(crush_map, row[0])
      crush_comment_count += 1
    end

  end
end

if options.normalize
  fan_map.each do |key, value|
    fan_map[key] = fan_map[key]/bulk_fan_map[key]
  end
  crush_map.each do |key, value|
    crush_map[key] = crush_map[key]/bulk_crush_map[key]
  end
end
max_fan_arr = fan_map.sort_by { |k, v| v }
max_fan_arr.reverse!
max_crush_arr = crush_map.sort_by { |k, v| v }
max_crush_arr.reverse!





puts "#{options.user_name}: #{comment_count}"
puts "\n\\----------------------------------------------------\n\n"
puts "#{fan_map.keys.length} fans in #{fan_comment_count} comments"



for i in 0..4
  puts "\n#{max_fan_arr[i][0].ljust(25)}: #{max_fan_arr[i][1]}"
end

puts "\n\\----------------------------------------------------\n\n"
puts "#{crush_map.keys.length} crushes in #{crush_comment_count} comments"



for i in 0..4
  puts "\n#{max_crush_arr[i][0].ljust(25)}: #{max_crush_arr[i][1]}"
end
