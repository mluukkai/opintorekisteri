class Statistic < ActiveRecord::Base
  attr_accessible :attrib, :attrib2, :started

  def aggregate year=2012
    Statistic.aggregate(Student.belonging_to(started, attrib, attrib2), year)
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

    students.each do |s|
      credits_year += s.credits_year year
      credits_completed_year += s.credits_completed_year year
      credits_tkt += s.credits_completed_year(year, "58")
      credits_math += s.credits_completed_year(year, "57")
      fiftyfive += 1 if s.credits_year(year) > 54
      zeros += 1 if s.credits_year(year) == 0
    end

    active_students = students.count-zeros

    if not students.nil? and ( students.first.attrib == "mooc" or ( students.first.attrib.include?"kesa" and students.last.attrib.include?"kesa" ))
      credits_completed_year = credits_completed_year-(9*active_students)
      credits_tkt = credits_tkt-(9*active_students)
      credits_tktactive = credits_tktactive-(9*active_students)
    end

    {
        :year => year,
        :total => (credits_year/active_students).round(2),
        :completed => (credits_completed_year/active_students).round(2),
        :tkt => (credits_tkt/active_students).round(2),
        :math => (credits_math/active_students).round(2),
        :other => ((credits_completed_year-credits_math-credits_tkt)/active_students).round(2),
        :students => students.count,
        :fiftyfive => fiftyfive,
        :zeros => zeros,
    }
  end

  # hack

  def month_aggregate year=2012
    Statistic.month_aggregate(Student.belonging_to(started, attrib, attrib2), year)
  end

  def self.month_aggregate students, year
    credits_year = 0
    credits_completed_year = 0
    zeros = 0
    fiftyfive = 0
    credits_tkt = 0
    credits_math = 0
    zerotkt = 0
    credits_tktactive = 0

    students.each do |s|
      credits_year += s.credits_in_months year
      credits_completed_year += s.credits_completed_in_months year
      credits_tkt += s.credits_completed_in_months(year, "58")
      credits_math += s.credits_completed_in_months(year, "57")
      fiftyfive += 1 if s.credits_in_months(year) > 54
      zeros += 1 if s.credits_in_months(year) == 0
    end

    active_students = students.count-zeros

    if not students.nil? and students.first.attrib != "norm"
      credits_completed_year = credits_completed_year-(9*active_students)
      credits_tkt = credits_tkt-(9*active_students)
      credits_tktactive = credits_tktactive-(9*active_students)
    end

    {
        :year => year,
        :total => (credits_year/active_students).round(2),
        :completed => (credits_completed_year/active_students).round(2),
        :tkt => (credits_tkt/active_students).round(2),
        :math => (credits_math/active_students).round(2),
        :other => ((credits_completed_year-credits_math-credits_tkt)/active_students).round(2),
        :students => students.count,
        :fiftyfive => fiftyfive,
        :zeros => zeros,
    }
  end

  # hack end

  def already_started year
    started[1..-1].to_i <= year
  end

  def to_s
    "#{started} #{attrib} #{attrib2}"
  end
end
