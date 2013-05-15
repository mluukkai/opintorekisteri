class Student < ActiveRecord::Base
  attr_accessible :attrib, :started, :student_number

  has_many :entries

  def self.belonging_to started, attrib, attrib2
    return Student.includes(:entries).where("started == ? and attrib == ?", started, attrib) if attrib2.nil? or attrib2.empty?
    Student.includes(:entries).where("started == ? and attrib == ? and attrib2 == ?", started, attrib, attrib2)
  end

  def credits
    success.inject(0) do |sum, e|
      sum += e.credits if likely_a_course e
      sum
    end
  end

  def not_a_course e
    e.code.start_with?('0') or e.credits > 15
  end

  def likely_a_course e
    not not_a_course(e) or ( e.name.include?("gradu") and not e.name.include?("ilman") )
  end

  def credits_after
    date1 = Date.new(2012,8,1)
    date2 = Date.new(2013,8,1)
    success_at_period(date1, date2).inject(0) do |sum, e|
      sum += e.credits if likely_a_course e
      sum
    end
  end

  def credits_year year, dep = nil
    date1 = Date.new(year,8,1)
    date2 = Date.new(year+1,8,1)
    success_at_period(date1, date2).inject(0) do |sum, e|
      sum += e.credits if ( dep.nil? or e.code.starts_with? dep) and likely_a_course e
      sum
    end
  end

  def credits_completed_year year, dep = nil
    date1 = Date.new(year,8,1)
    date2 = Date.new(year+1,8,1)
    completed_at_period(date1, date2).inject(0) do |sum, e|
      sum += e.credits if (dep.nil? or e.code.starts_with? dep ) and likely_a_course e
      sum
    end
  end

  def other_credits_completed_year year
    credits_completed_year(year) - credits_completed_year(year,"58") -credits_completed_year(year,"57")
  end

  # hack_begin

  def credits_in_months month
    start_year = started[1..-1].to_i
    date1 = Date.new(start_year,8,1)
    date2 = date1 + month.month
    success_at_period(date1, date2).inject(0) do |sum, e|
      sum += e.credits if likely_a_course e
      sum
    end
  end

  def credits_completed_in_months month, dep = nil
    start_year = started[1..-1].to_i
    date1 = Date.new(start_year,8,1)
    date2 = date1 + month.month
    success_at_period(date1, date2).inject(0) do |sum, e|
      sum += e.credits if (dep.nil? or e.code.starts_with? dep ) and likely_a_course e
      sum
    end
  end

  def other_credits_completed_in_months months
    credits_completed_in_months(months) - credits_completed_in_months(months,"58") -credits_completed_in_months(months,"57")
  end

  # hack_end

  def success
    entries.where("statuscode != ? ", 10)
  end

  def failed
    entries.where( :statuscode => 10 )
  end

  def completed_at_period date1, date2
    entries.where("statuscode == ? and date >= ? and date < ?", 4, date1, date2)
  end

  def success_at_period date1, date2
    entries.where("statuscode != ? and date >= ? and date < ?", 10, date1, date2)
  end
end
