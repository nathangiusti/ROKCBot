require 'csv'
require 'date'

poster_un = ARGV[2]
start_date = Date.parse(ARGV[0])
end_date = Date.parse(ARGV[1])
ARCHIVE_DIR = "archive"

#Generate a list of dates
date_list = []
for next_date in (start_date..end_date)
  date_list << "#{next_date.strftime('%Y%m%d')}"
end


for date in date_list
  reply_csv = CSV.open("#{ARCHIVE_DIR}/Reply_#{date}.txt")
  comment_csv = File.open("#{ARCHIVE_DIR}/Comment_#{date}.txt")

  #Get number of comments by user
  count = 0
  comment_csv.each do |line|
    if line.strip == poster_un
      count += 1
    end
  end

  crush_map = {}
  fan_map = {}

  fan_count = 0;
  crush_count = 0;

  reply_csv.each do |row|
    unless row[0] == poster_un || row[1] == poster_un
      next
    else
      if row[0] == poster_un
        fan_count += 1
        if fan_map.key?(row[1])
          fan_map[row[1]] = fan_map[row[1]]+1
        else
          fan_map[row[1]] = 1
        end
      else
        crush_count += 1
        if crush_map.key?(row[0])
          crush_map[row[0]] = crush_map[row[0]]+1
        else
          crush_map[row[0]] = 1
        end
      end
    end
  end
end

puts "#{poster_un}: #{count}"
puts "\n\\----------------------------------------------------\n"
puts "#{fan_map.keys.length} fans in #{fan_count} comments"

max_fan_arr = fan_map.sort_by { |k, v| v }
max_fan_arr.reverse!

for i in 0..4
  puts "\n#{max_fan_arr[i][0].ljust(25)}: #{max_fan_arr[i][1]}"
end

puts "\n\\----------------------------------------------------\n"
puts "#{crush_map.keys.length} fans in #{crush_count} comments"

max_crush_arr = crush_map.sort_by { |k, v| v }
max_crush_arr.reverse!

for i in 0..4
  puts "\n#{max_crush_arr[i][0].ljust(25)}: #{max_crush_arr[i][1]}"
end
