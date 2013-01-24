class UserRepoWork < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  attr_accessible :user, :repo, :path
end
