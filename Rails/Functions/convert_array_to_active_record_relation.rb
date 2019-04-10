users_temp =[]

user_temp.push(User.first)
user_temp.push(User.last)

users = User.where(id: users_temp.map(&:id))