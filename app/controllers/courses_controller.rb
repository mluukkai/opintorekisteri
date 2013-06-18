class CoursesController < ApplicationController

  def index
    @courses = Course.all.sort_by { |c| c.to_s }

    if params[:course]
      @dates = [1, Entry.where(:name => params[:course]).map{|m|m.date}.uniq.sort.join(" ")]
    end


    respond_to do |format|
      format.html
      format.json { render :json => @dates }
    end
  end

  def show
    @course = Course.find(params[:id])

    if stale?(:last_modified => @course.updated_at.utc, :etag => @course)

      date = @course.date
      months = @course.months_since

      @plot1 = plot_from @course.students_completed, date, months
      @map1 = map_from @course.students_completed

      @plot2 = plot_from @course.students_failed, date, months
      @map2 = map_from @course.students_failed

      #max1 = stripped(@plot1).split(',').map { |e| e.to_i }.max
      #max2 = stripped(@plot2).split(',').map { |e| e.to_i }.max
      @max = [max(@plot1), max(@plot2)].max
    end
  end

  def max plot
    plot.flatten.to_s.gsub(/\"/, '').gsub(/\[/, '').gsub(/\]/, '').split(',').map { |e| e.to_i }.max
  end

  def dates
    [
        ['tira', '01.01.2010, 02.02.2011'],
        ['ohpe', '22.03.2009, 03.01.2013'],
    ]
  end

  def plot_from students, date, months
    students_considered = students.inject([]) { |set, s| set << s.progress_since(date, months) }

    plot = (1..months).inject([]) do |set, m|
      row = [m]
      students_considered.each do |s|
        row << s[m-1]
      end
      set << row.to_s.chop[1..-1]
    end

    plot
  end

  def map_from students
    map = []
    i = 1
    students.each do |s|
      map << [i, s.id]
      i+=1
    end
    map
  end

  def new
    @course = Course.new
  end

  def edit
    @course = Course.find(params[:id])
  end

  def create
    @course = Course.new(params[:course])


    if @course.save
      redirect_to @course, :notice => 'Course was successfully created.'
    else
      render :action => "new"
    end

  end

  def update
    @course = Course.find(params[:id])

    if @course.update_attributes(params[:course])
      redirect_to @course, :notice => 'Course was successfully updated.'
    else
      render :action => "edit"
    end
  end
end

def destroy
  @course = Course.find(params[:id])
  @course.destroy
end

