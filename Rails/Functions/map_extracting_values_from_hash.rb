 # extract values from especific field in hash
channels = Channel.all
channels = channels.map(&:name).flatten

# with distinct sql attribute
channels = Channel.all
channels = channels.map(&:name).flatten.uniq

# function flatten - set elements at same level
[[1,2,3],[8,9]].flatten # => [1, 2, 3, 8, 9]