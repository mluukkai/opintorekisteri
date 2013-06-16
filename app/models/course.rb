class Course < ActiveRecord::Base
  attr_accessible :date, :name, :term

  def students
    entries = Entry.where(:name => name, :statuscode => 4, :date => date)
    entries.map{|s|s.student}
  end

  def months_since
    ((Date.today-date)/30).to_i+1
  end
end
