require_relative 'PostData.rb'
require_relative 'PostCount.rb'
require_relative 'Crushes.rb'
require_relative 'TrueCrushes.rb'
require_relative 'Utilities.rb'


puts "Building database"
pd = PostData.new("archive")
pc = PostCount.new(pd)
puts "Filtering database"
cj_filter = pc.get_filter(100)
pd_filter = PostData.new("archive", cj_filter)
puts "Calculating max rating"
max_rating = find_max_rating(cj_filter, pd_filter)
puts "\n\n"

puts "There were #{pc.get_total_number_comments.round(0)} comments from #{pc.get_total_number_users} different user names"
puts "The top 10 commenters are #{(pc.get_total_score(10)/pc.get_total_score*100).round(0)}% of the sub"
puts "The top 100 commenters are #{(pc.get_total_score(100)/pc.get_total_score*100).round(0)}% of the sub"
puts "\n\n"

cj_filter[0..9].each do |un|
  puts pc.get_simple_user_info_string(un)
end

puts "\n\n"

while true
  print " > "
  line = gets
  line.strip!

  unless pc.does_user_exist line
    puts "No such user #{line}"
    next
  end

  crushes = Crushes.new(pd, line)

  disp_str = ""
  disp_str << pc.get_user_info_string(line)
  disp_str << crushes.get_user_info_string

  if cj_filter.include? line
    t_crushes = TrueCrushes.new(pd_filter, line, max_rating)
    disp_str << t_crushes.get_user_info_string
  end

  copy_to_clipboard(disp_str)
  puts disp_str

end



