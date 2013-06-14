class StudentsController < ApplicationController

  def index
    @students = Student.all
  end

  def show
    @student = Student.find(params[:id])

    i = 1
    @plot = []
    @student.progress.each do |s|
      @plot << [i, s]
      i += 1
    end
  end

  def new
    @student = Student.new
  end

  def edit
    @student = Student.find(params[:id])
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(params[:student])

    exists = Student.where(:student_number => @student.student_number)

    respond_to do |format|
      if exists.empty? and @student.save
        format.html { redirect_to @student, :notice => 'Student was successfully created.' }
        format.json { render :json => @student, :status => :created, :location => @student }
      else
        format.html { render :action => "new" }
        format.json { render :json => @student, :status => :created, :location => @student }
      end
    end
  end

  # PUT /students/1
  # PUT /students/1.json
  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to @student, :notice => 'Student was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @student.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student = Student.find(params[:id])
    @student.destroy

  end
end
