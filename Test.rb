require_relative 'PostData.rb'
require_relative 'PostCount.rb'
require_relative 'Crushes.rb'
require_relative 'TrueCrushes.rb'

pd = PostData.new("archive")
pc = PostCount.new(pd)
crushes = Crushes.new(pd, ARGV[0])
cj_filter = pc.get_filter(100)

puts pc.get_user_info_string ARGV[0]
puts crushes.get_user_info_string

if cj_filter.include? ARGV[0]
  t_crushes = TrueCrushes.new(pd, ARGV[0], cj_filter)
  puts t_crushes.get_user_info_string
end



