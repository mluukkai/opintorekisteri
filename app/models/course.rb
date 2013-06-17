class Course < ActiveRecord::Base
  attr_accessible :date, :date2, :name, :term

  def students_completed
    ( students_completed1 + ( students_failed1 & students_completed2 ) ).uniq
  end

  def students_failed
    ( students_failed1 - students_completed2 ).uniq
  end

  def students_completed1
    Entry.where(:name => name, :statuscode => 4, :date => date).map{|s|s.student}
  end

  def students_completed2
    return [] if date2.nil?
    Entry.where(:name => name, :statuscode => 4, :date => date2).map{|s|s.student}
  end

  def students_failed1
    Entry.where(:name => name, :statuscode => 10, :date => date).map{|s|s.student}
  end

  def students_failed2
    return [] if date2.nil?
    Entry.where(:name => name, :statuscode => 10, :date => date2).map{|s|s.student}
  end

  def months_since
    ((Date.today-date)/30).to_i+1
  end

  def to_s
    "#{name} #{term}"
  end
end
