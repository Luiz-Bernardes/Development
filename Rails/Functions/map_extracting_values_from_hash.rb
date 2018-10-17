 # extract values from especific field in hash
channels = channels.map(&:name).flatten

# with distinct sql attribute
channels = channels.map(&:name).flatten.uniq