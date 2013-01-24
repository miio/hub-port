class UserRepo < ActiveRecord::Base
  belongs_to :user
  belongs_to :repo
  attr_accessible :user, :repo

  def working
    WorkingRepo.new self.user, self.repo
  end

end
