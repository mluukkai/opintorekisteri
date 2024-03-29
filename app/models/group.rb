class Group < ActiveRecord::Base
  attr_accessible :description, :name, :start_year

  has_many :memberships
  has_many :students, :through => :memberships

  def self.started year
    start_year = year[1..-1].to_i
    Group.where :start_year => start_year
  end

  def self.current_year
    2013
  end

  def recent_aggregate
    aggregate 2013
  end

  def aggregate year
    if not Rails.cache.exist? "#{name} #{year}"
      Rails.cache.write "#{name} #{year}", Group.aggregate(students, year)
    end
    Rails.cache.read "#{name} #{year}"
  end

  def self.aggregate students, year
    credits_year = 0
    credits_completed_year = 0
    zeros = 0
    fiftyfive = 0
    credits_tkt = 0
    credits_math = 0
    zerotkt = 0
    credits_tktactive = 0
    ag = 0
    graded = 0

    students.each do |s|
      credits_year += s.credits_registered_year year
      credits_completed_year += s.credits_completed_year year
      credits_tkt += s.tkt_credits_completed_year(year)
      credits_math += s.math_credits_completed_year(year)
      fiftyfive += 1 if s.credits_registered_year(year) > 54
      zeros += 1 if s.credits_registered_year(year) == 0
      grade = s.average_grade
      if grade>0
        ag += grade
        graded += 1
      end

    end

    active_students = students.count-zeros

    {
        :year => year,
        :registered => active_students==0 ? 0 : (credits_year/active_students).round(2),
        :completed => active_students==0 ? 0 : (credits_completed_year/active_students).round(2),
        :tkt => active_students==0 ? 0 : (credits_tkt/active_students).round(2),
        :math => active_students==0 ? 0 : (credits_math/active_students).round(2),
        :other => active_students==0 ? 0 : ((credits_completed_year-credits_math-credits_tkt)/active_students).round(2),
        :students => students.count,
        :fiftyfive => fiftyfive,
        :zeros => zeros,
        :grade => graded>0 ? (ag/graded).round(2) : 0
    }
  end
end
