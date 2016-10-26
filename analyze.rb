require 'csv'


reply_csv = CSV.open(ARGV[0])
poster_un = ARGV[2]

count = 0
File.open(ARGV[1]).each do |line|
  if line.strip == poster_un
    count += 1
  end
end

puts ""
puts ""

puts "#{poster_un}: #{count}"


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
max_fan_arr = fan_map.max_by { |k, v| v }
max_crush_arr = crush_map.max_by { |k, v| v }

puts ""

puts "\\----------------------------------------------------"

puts ""

puts "#{fan_map.keys.length} fans in #{fan_count} comments"
i = 0
while i < 5 do
  un = fan_map.max_by { |k, v| v }[0]
  if fan_map[un] > 0
    puts ""
    puts "#{un.ljust(25)} : #{fan_map[un]}"
    fan_map[un] = 0
  end
  i += 1
end

puts ""


puts "\\----------------------------------------------------"

puts ""

puts "#{crush_map.keys.length} crushes in #{crush_count} comments"
i = 0
while i < 5 do
  un = crush_map.max_by { |k, v| v }[0]
  if crush_map[un] > 0
    puts ""
    puts "#{un.ljust(25)} : #{crush_map[un]}"
    crush_map[un] = 0
  end
  i += 1
end

