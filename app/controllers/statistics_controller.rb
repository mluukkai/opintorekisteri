class StatisticsController < ApplicationController
  caches_action :index

  # GET /statistics
  # GET /statistics.json
  def index
    @statistics = Statistic.all.sort_by { |s| s.attrib }
    @keys = @statistics.first.aggregate.keys

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @statistics }
    end
  end

  # GET /statistics/1
  # GET /statistics/1.json
  def show
    @statistic = Statistic.find(params[:id])
    @students = Student.belonging_to(@statistic.started, @statistic.attrib, @statistic.attrib2)

    if params[:order] == "credits_total"
      @students.sort_by! { |s| s.credits }
    elsif params[:order] == "credits_registered"
      @students.sort_by! { |s| s.credits_year(2012) }
    elsif params[:order] == "credits_completed"
      @students.sort_by! { |s| s.credits_completed_year(2012) }
    elsif params[:order] == "tkt_credits_completed"
      @students.sort_by! { |s| s.credits_completed_year(2012, "58") }
    elsif params[:order] == "math_credits_completed"
      @students.sort_by! { |s| s.credits_completed_year(2012, "57") }
    elsif params[:order] == "other_credits_completed"
      @students.sort_by! { |s| s.other_credits_completed_year(2012) }
    else
      @students.sort_by! { |s| s.credits_completed_year(2012) }
    end

    @students.reverse!
    @aggregate = Statistic.aggregate @students

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @statistic }
    end
  end

  # GET /statistics/new
  # GET /statistics/new.json
  def new
    @statistic = Statistic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @statistic }
    end
  end

  # GET /statistics/1/edit
  def edit
    @statistic = Statistic.find(params[:id])
  end

  # POST /statistics
  # POST /statistics.json
  def create
    @statistic = Statistic.new(params[:statistic])

    respond_to do |format|
      if @statistic.save
        format.html { redirect_to @statistic, :notice => 'Statistic was successfully created.' }
        format.json { render :json => @statistic, :status => :created, :location => @statistic }
      else
        format.html { render :action => "new" }
        format.json { render :json => @statistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /statistics/1
  # PUT /statistics/1.json
  def update
    @statistic = Statistic.find(params[:id])

    respond_to do |format|
      if @statistic.update_attributes(params[:statistic])
        format.html { redirect_to @statistic, :notice => 'Statistic was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @statistic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /statistics/1
  # DELETE /statistics/1.json
  def destroy
    @statistic = Statistic.find(params[:id])
    @statistic.destroy

    respond_to do |format|
      format.html { redirect_to statistics_url }
      format.json { head :no_content }
    end
  end
end
