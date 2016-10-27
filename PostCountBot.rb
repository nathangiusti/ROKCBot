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

post_map = {}

for date in date_list
  comment_csv = File.open("#{ARCHIVE_DIR}/Comment_#{date}.txt")

  count = 0
  comment_csv.each do |line|
    line.strip!

    if post_map.key?(line)
      post_map[line] = post_map[line]+1
    else
      post_map[line] = 1
    end

  end
end

poster_arr = post_map.sort_by { |k, v| v }
poster_arr.reverse!

for k,v in poster_arr
  puts "#{k},#{v}"
end
