class Entry < ActiveRecord::Base
  attr_accessible :code, :creditDate, :credits, :date, :grade, :name, :ordering, :status, :statuscode, :student_number

  belongs_to :student

end
