class Issue < ActiveRecord::Base
  belongs_to :repo
  attr_accessible :object, :title
end
