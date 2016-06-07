class GroupsUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
end

class User < ActiveRecord::Base
  has_many :groups_users
  has_many :groups, through: :groups_users
end

class Group < ActiveRecord::Base
  has_many :groups_users
  has_many :users, through: :groups_users
end
