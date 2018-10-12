# add migration
$ rails g migration add_kind_to_users

# run migrate
$ rake db:migrate

# db/config/migration - add
class AddKindToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :kind, :string
  end
end

# db/config/migration - remove
class RemoveKindFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :kind
  end
end

