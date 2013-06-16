class Entry < ActiveRecord::Base
  attr_accessible :code, :creditDate, :credits, :date, :grade, :name, :ordering, :status, :statuscode, :student_number

  belongs_to :student

  def self.unknown? entry
    Entry.where( :student_number => entry.student_number,
                 :date => entry.date,
                 :name => entry.name,
                 :grade => entry.grade).empty?
  end
end
