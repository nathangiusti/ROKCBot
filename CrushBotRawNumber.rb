require 'csv'
require 'date'
require 'optparse'
require 'ostruct'
require_relative 'Utilities.rb'

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

end.parse!

unless options.start_date.nil? || options.end_date.nil?
  start_date = Date.parse(options.start_date)
  end_date = Date.parse(options.end_date)
else
  start_date = Date.parse("20161010")
  end_date = Date.parse(Time.now.to_s)
end

@@filter_array = nil
ARCHIVE_DIR = "archive"
#Generate a list of dates
date_list = []
for next_date in (start_date..end_date)
  date_list << "#{next_date.strftime('%Y%m%d')}"
end

normalized = false

unless options.filter_list.nil?
  @@filter_array = []
  filter_file = File.open(options.filter_list)
  filter_file.each do |line|
    @@filter_array.push(line.strip)
  end

  if @@filter_array.include?(options.user_name)
    normalized = true
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
  begin
    reply_csv = CSV.open("#{ARCHIVE_DIR}/Reply_#{date}.txt")
    comment_csv = File.open("#{ARCHIVE_DIR}/Comment_#{date}.txt")
  rescue Exception
    break
  end


  #Get number of comments by user
  comment_csv.each do |line|
    if line.strip == options.user_name
      comment_count += 1
    end
  end


  reply_csv.each do |row|

    if is_not_filtered?(row[1]) && is_not_filtered?(row[0])
      increment_map(bulk_fan_map, row[1], 0)
      increment_map(bulk_crush_map, row[0], 0)
    end

    if row[0] == options.user_name && is_not_filtered?(row[1])
      increment_map(fan_map, row[1], 0)
      fan_comment_count += 1
    elsif row[1] == options.user_name && is_not_filtered?(row[0])
      increment_map(crush_map, row[0], 0)
      crush_comment_count += 1
    end

  end
end

stalker_map = {}
fan_map.each do |key, value|
  if crush_map.key?(key) && fan_map[key] > crush_map[key]
    stalker_map[key] = fan_map[key] - crush_map[key]
  else
    stalker_map[key] = fan_map[key]
  end
end

stalkee_map = {}
crush_map.each do |key, value|
  if fan_map.key?(key) && crush_map[key] > fan_map[key]
    stalkee_map[key] = crush_map[key] - fan_map[key]
  else
    stalkee_map[key] = crush_map[key]
  end
end

normalize_fan_map = {}
normalize_crush_map = {}

if normalized

  fan_map.each do |key, value|
    normalize_fan_map[key] = fan_map[key]/bulk_fan_map[key] * 100
  end
  crush_map.each do |key, value|
    normalize_crush_map[key] = crush_map[key]/bulk_crush_map[key] * 100
  end

  normalize_max_fan_arr = map_to_sorted_arr(normalize_fan_map)
  normalize_max_crush_arr = map_to_sorted_arr(normalize_crush_map)
end

max_stalkee_arr = map_to_sorted_arr(stalkee_map)
max_stalker_arr = map_to_sorted_arr(stalker_map)
max_fan_arr = map_to_sorted_arr(fan_map)
max_crush_arr = map_to_sorted_arr(crush_map)

puts "#{options.user_name}: #{comment_count}"
puts "\n\\----------------------------------------------------\n\n"
puts "#{fan_map.keys.length} fans in #{fan_comment_count} comments"

begin
  max_fan_arr[0..4].each do |obj|
    puts "\n#{obj[0].ljust(25)}: #{obj[1].round(0)}"
  end
rescue Exception
end

puts "\n\\----------------------------------------------------\n\n"
puts "#{crush_map.keys.length} crushes in #{crush_comment_count} comments"
begin
  max_crush_arr[0..4].each do |obj|
    puts "\n#{obj[0].ljust(25)}: #{obj[1].round(0)}"
  end
rescue Exception
end

puts "\n\\----------------------------------------------------\n\n"
puts "Stalks #{stalkee_map.keys.length}"

begin
  max_stalkee_arr[0..4].each do |obj|
    puts "\n#{obj[0].ljust(25)}: #{obj[1].round(0)}"
  end
rescue Exception
end

puts "\n\\----------------------------------------------------\n\n"
puts "Stalked by #{stalker_map.keys.length}"

begin
  max_stalker_arr[0..4].each do |obj|
    puts "\n#{obj[0].ljust(25)}: #{obj[1].round(0)}"
  end
rescue Exception
end

if normalized
  puts "\n\\----------------------------------------------------\n\n"
  puts "Your true fans"

  begin
    normalize_max_fan_arr[0..4].each do |obj|
      puts "\n#{obj[0].ljust(25)}: #{obj[1].round(0)}%"
    end
  rescue Exception
  end

  puts "\n\\----------------------------------------------------\n\n"
  puts "Your true crushes"

  begin
    normalize_max_crush_arr[0..4].each do |obj|
      puts "\n#{obj[0].ljust(25)}: #{obj[1].round(0)}%"
    end
  rescue Exception
  end
end

puts "\n\n"
