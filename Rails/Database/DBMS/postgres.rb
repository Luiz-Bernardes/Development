# server connect
sudo -u postgres psql

# prompt access
psql

# quit
\q

# list all databases 
\l, \list

# all tables current database
\dt

# change database
\connect database_name or \c database_name

# list users
\du

# change password
ALTER USER user_name WITH PASSWORD 'new_password';