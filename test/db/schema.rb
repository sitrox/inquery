ActiveRecord::Schema.define do
  self.verbose = false

  create_table :groups, force: true do |t|
    t.string :name
    t.timestamps
  end

  create_table :users, force: true do |t|
    t.string :name
    t.timestamps
  end

  create_table :groups_users, force: true do |t|
    t.integer :group_id
    t.integer :user_id
    t.timestamps
  end
end
