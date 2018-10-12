puts "\n"

list = Array.new
bets = 11
numbers      = [1,2,3,4,5,6,7,8,12,13,15,17,18,20,21,22,23,24,25]
not_included = [9,10,11,14,16,19]

puts "LIST.."
for x in numbers
  print "#{x} "
end

puts "\n"
puts "\n"
puts "SORTING.."

for i in 1..bets do
  sorted  = numbers.sample(15)
  ordered = sorted.sort_by(&:to_i)

  print ordered

  puts "\n"
  puts "\n"

  list.push(ordered)
end


puts "RESULT:"
print list
puts "\n"
puts "\n"
