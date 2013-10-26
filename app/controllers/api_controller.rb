class ApiController < ApplicationController
  def student
    @student = Student.find(params[:id], :include => :entries )

    render :json => @student, :methods => [ :credits_total, :entries ]
  end

  def groups
    @groups = Group.all.sort_by { |g| g.name }

    render :json => @groups
  end

  def group
    @group = Group.find(params[:id])

    response = {}
    response[:group] = @group
    response[:years] = []

    years = []
    (@group.start_year..2012).each do |year|
      years << @group.aggregate(year)
    end

    response[:years] = years.reverse

    render :json => response
  end

  def group_year
    id = params[:id]
    year = params[:year].to_i
    sorted = params[:sorted] || "credits_registered_year"

    group = Group.find(id, :include => :students)

    unless Rails.cache.exist?("agregate #{id} #{year}")
      Rails.cache.write("agregate #{id} #{year}", group.aggregate(year))
    end

    stats = Rails.cache.read("agregate #{id} #{year}")

    response = {}
    response[:group] = group
    response[:stats] = stats

    students = group.students.sort_by! { |s| s.send(sorted, year ) }  #.sort_by! { |s| s.send(sorted, (params[:year].to_i)) }

    response[:plot] = plot(students, sorted, id, year)

    render :json => response
  end

  def plot(students, sorted, id, year)
    unless Rails.cache.exist?("plot #{id} #{year} #{sorted}")
      i = 1
      plot = []
      students.each do |s|
        plot << [i, s.send(sorted, year).to_i, s.id]
        i += 1
      end
      plot
      Rails.cache.write("plot #{id} #{year} #{sorted}", plot)
    end

    Rails.cache.read("plot #{id} #{year} #{sorted}")
  end
end
