class Repo < ActiveRecord::Base
  attr_accessible :id, :name, :object, :owner, :work_path
end
