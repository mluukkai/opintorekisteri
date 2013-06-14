class StatisticsController < ApplicationController
  caches_action :index

  # GET /statistics
  # GET /statistics.json
  def index
    @statistics = Statistic.all.sort_by { |s| s.started }
    @keys = @statistics.first.aggregate.keys

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @statistics }
    end
  end

  def touch
    @statistic = Statistic.find(params[:id])
    @statistic.touch

    redirect_to :back
  end

  # GET /statistics/1
  # GET /statistics/1.json
  def show
    @statistic = Statistic.find(params[:id])

    if stale?(:last_modified => @statistic.updated_at.utc, :etag => @statistic)

      if params[:year]
        @year = params[:year].to_i
      else
        @year = 2012
      end

      @students = Student.belonging_to(@statistic.started, @statistic.attrib, @statistic.attrib2)

      if params[:order] == "credits_total"
        m = "credits"
        @students.sort_by! { |s| s.credits_total }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.credits.to_i, s.id]
          i += 1
        end

      elsif params[:order] == "credits_registered"
        m = "credits_year"
        @students.sort_by! { |s| s.credits_registered_year(@year) }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.credits_year(@year).to_i, s.id]
          i += 1
        end

      elsif params[:order] == "tkt_credits_completed"
        @students.sort_by! { |s| s.tkt_credits_completed_year(@year) }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.tkt_credits_completed_year(@year).to_i, s.id]
          i += 1
        end

      elsif params[:order] == "math_credits_completed"
        @students.sort_by! { |s| s.math_credits_completed_year(@year).to_i }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.math_credits_completed_year(@year).to_i, s.id]
          i += 1
        end

      elsif params[:order] == "other_credits_completed"
        @students.sort_by! { |s| s.other_credits_completed_year(@year) }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.other_credits_completed_year(@year).to_i, s.id]
          i += 1
        end
      else
        #"credits_completed_year"
        @students.sort_by! { |s| s.credits_completed_year(@year) }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.credits_completed_year(@year).to_i, s.id]
          i += 1
        end
      end

      @sorted = params[:order]

      @students.reverse!
      @aggregate = Statistic.aggregate @students, @year

      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @statistic }
      end
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


  # GET /statistics/1
  # GET /statistics/1.json
  def show_month_after
    @statistic = Statistic.find(params[:id])

    if stale?(:last_modified => @statistic.updated_at.utc, :etag => @statistic)

      @year = params[:month].to_i

      @students = Student.belonging_to(@statistic.started, @statistic.attrib, @statistic.attrib2)

      if params[:order] == "credits_total"
        m = "credits"
        @students.sort_by! { |s| s.credits }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.credits.to_i]
          i += 1
        end

      elsif params[:order] == "credits_registered"
        m = "credits_year"
        @students.sort_by! { |s| s.credits_in_months(@year) }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.credits_in_months(@year).to_i]
          i += 1
        end

      elsif params[:order] == "tkt_credits_completed"
        @students.sort_by! { |s| s.credits_completed_in_months(@year, "58") }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.credits_completed_in_months(@year, "58").to_i]
          i += 1
        end

      elsif params[:order] == "math_credits_completed"
        @students.sort_by! { |s| s.credits_completed_in_months(@year, "57").to_i }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.credits_completed_in_months(@year, "57").to_i]
          i += 1
        end

      elsif params[:order] == "other_credits_completed"
        @students.sort_by! { |s| s.other_credits_completed_in_months(@year).to_i }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.other_credits_completed_in_months(@year).to_i]
          i += 1
        end
      else
        @students.sort_by! { |s| s.credits_completed_in_months(@year).to_i }

        i = 1
        @plot = []
        @students.each do |s|
          @plot << [i, s.credits_completed_in_months(@year).to_i]
          i += 1
        end
      end

      @sorted = params[:order] || "credits_completed_year"

      @students.reverse!
      @aggregate = Statistic.month_aggregate @students, @year

      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @statistic }
      end
    end
  end
end
