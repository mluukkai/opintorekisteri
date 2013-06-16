class CoursesController < ApplicationController

  def index
    @courses = Course.all

  end

  def show
    @course = Course.find(params[:id])

    students = @course.students.inject([]) { |set, s| set << s.progress }
    @plot = (1..@course.students.first.months_studied).inject([]) do |set, m|
      row = [m]
      students.each do |s|
        row << s[m-1]
      end
      set << row.to_s.chop[1..-1]
    end

    @map = []
    i = 1
    @course.students.each do |s|
      @map << [i, s.id]
      i+=1
    end

  end

  def new
    @course = Course.new

  end

  # GET /courses/1/edit
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

