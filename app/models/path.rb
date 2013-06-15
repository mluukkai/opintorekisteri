class Path < ActiveRecord::Base
  attr_accessible :started

  def groups
    Group.started started
  end
end
