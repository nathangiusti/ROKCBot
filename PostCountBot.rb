require 'date'
require 'optparse'
require 'ostruct'

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

  opts.on("-f file", "--file file") do |v|
    options.file = v
  end

  opts.on("-l limit", "--limit limit") do |v|
    options.limit = v
  end

end.parse!

start_date = Date.parse(options.start_date)
end_date = Date.parse(options.end_date)

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

if options.limit.nil?
  cutoff = poster_arr.length
else
  cutoff = options.limit.to_i
end

output_string = ""

for i in 0..cutoff
  output_string << "#{poster_arr[i][0]}\n"
end

if !options.file.nil? 
  output = File.open(options.file, 'w')
  output.write(output_string)
else
  puts output_string
end

