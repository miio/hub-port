class Branch < ActiveRecord::Base
  belongs_to :repo
  attr_accessible :name, :object
end
