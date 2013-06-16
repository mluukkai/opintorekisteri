class Student < ActiveRecord::Base
  attr_accessible :attrib, :started, :student_number, :month_credits

  serialize :month_credits

  has_many :entries
  has_many :memberships
  has_many :groups, :through => :memberships

  def self.belonging_to started, attrib, attrib2
    return Student.includes(:entries).where("started == ? and attrib LIKE ?", started, "%#{attrib}%") if attrib2.nil? or attrib2.empty?
    #Student.includes(:entries).where("started == ? and attrib == ? and attrib2 == ?", started, attrib, attrib2)
    Student.includes(:entries).where("started == ? and attrib LIKE ? and attrib2 LIKE ?", started, "%#{attrib}%", "%#{attrib2}%")
  end

  def months_studied
    start_year = started[1..-1].to_i
    date1 = Date.new(start_year, 8, 1)
    ((Date.today - date1)/30).to_i
  end

  def progress
    (1..months_studied).inject([]) do |progr, m|
      progr << credits_in_months(m).to_i
    end
  end

  def member_of group
    groups.include? group
  end

  def has_completed course
    entries.each do |e|
      return true if not e.name.nil? and e.name.include? course and e.statuscode != 10
    end
    false
  end

  # reason for useless parameter is to keep interface similar to other methods
  def credits_total year = 0
    success.inject(0) do |sum, e|
      sum += e.credits if likely_a_course e
      sum
    end
  end

  def tkt_credits
    success.inject(0) do |sum, e|
      sum += e.credits if likely_a_course e and e.code.start_with?('58')
      sum
    end
  end

  def credits_after
    date1 = Date.new(2012, 8, 1)
    date2 = Date.new(2013, 8, 1)
    success_at_period(date1, date2).inject(0) do |sum, e|
      sum += e.credits if likely_a_course e
      sum
    end
  end

  def average_grade
    credits = 0
    number_sum = 0
    entries.each do |e|
      if likely_a_course(e) and (e.grade.to_i) > 0
        number_sum += e.grade.to_i * e.credits
        credits += e.credits
      end
    end
    return 0 if credits == 0
    number_sum / credits
  end

  # year

  def credits_registered_year year, dep = nil
    date1 = Date.new(year, 8, 1)
    date2 = Date.new(year+1, 8, 1)
    success_at_period(date1, date2).inject(0) do |sum, e|
      sum += e.credits if (dep.nil? or e.code.starts_with? dep) and likely_a_course e
      sum
    end
  end

  def tkt_credits_completed_year year
    credits_completed_year(year, "58")
  end

  def math_credits_completed_year year
    credits_completed_year(year, "57")
  end

  def credits_completed_year year, dep = nil
    date1 = Date.new(year, 8, 1)
    date2 = Date.new(year+1, 8, 1)
    completed_at_period(date1, date2).inject(0) do |sum, e|
      sum += e.credits if (dep.nil? or e.code.starts_with? dep) and likely_a_course e
      sum
    end
  end

  def other_credits_completed_year year
    credits_completed_year(year) - credits_completed_year(year, "58") -credits_completed_year(year, "57")
  end

  # hack_begin

  def credits_in_months month
    if not month_credits.nil? and month_credits[month]
      return month_credits[month]
    end

    start_year = started[1..-1].to_i
    date1 = Date.new(start_year, 8, 1)
    date2 = date1 + month.month
    cred = success_at_period(date1, date2).inject(0) do |sum, e|
      sum += e.credits if likely_a_course e
      sum
    end

    if self.month_credits.nil?
      self.month_credits = {}
    end

    self.month_credits[month] = cred
    self.save
    cred
  end

  def credits_completed_in_months month, dep = nil
    start_year = started[1..-1].to_i
    date1 = Date.new(start_year, 8, 1)
    date2 = date1 + month.month
    success_at_period(date1, date2).inject(0) do |sum, e|
      sum += e.credits if (dep.nil? or e.code.starts_with? dep) and likely_a_course e
      sum
    end
  end

  def other_credits_completed_in_months months
    credits_completed_in_months(months) - credits_completed_in_months(months, "58") -credits_completed_in_months(months, "57")
  end

  # hack_end

  def success
    entries.where("statuscode != ? ", 10)
  end

  def failed
    entries.where(:statuscode => 10)
  end

  def completed_at_period date1, date2
    entries.where("statuscode == ? and date >= ? and date < ?", 4, date1, date2)
  end

  # sisältää hyväksiluetut
  def success_at_period date1, date2
    entries.where("statuscode != ? and date >= ? and date < ?", 10, date1, date2)
  end

  def not_a_course e
    e.code.start_with?('0') or e.credits > 15
  end

  def likely_a_course e
    not not_a_course(e) or (e.name.include?("gradu") and not e.name.include?("ilman"))
  end
end
