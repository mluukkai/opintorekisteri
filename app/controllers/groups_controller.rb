class GroupsController < ApplicationController

  def index
    @groups = Group.all.sort_by { |g| g.name }
    @keys = @groups.first.aggregate(2012).keys
  end

  def show
    @group = Group.find(params[:id])

    raise if params[:order].nil?

    @sorted = params[:order]

    if params[:year]
      @year = params[:year].to_i
    else
      @year = 2012
    end

    @aggregate = {}
    (@group.start_year..2012).each do |y|
      @aggregate[y] = @group.aggregate y
    end

    @students = @group.students

    if params[:order] == "credits_total"
      @students.sort_by! { |s| s.credits_total(@year) }

      i = 1
      @plot = []
      @students.each do |s|
        @plot << [i, s.credits_total(@year).to_i, s.id]
        i += 1
      end

    elsif params[:order] == "credits_registered_year"
      @students.sort_by! { |s| s.credits_registered_year(@year) }

      i = 1
      @plot = []
      @students.each do |s|
        @plot << [i, s.credits_registered_year(@year).to_i, s.id]
        i += 1
      end

    elsif params[:order] == "tkt_credits_completed_year"
      @students.sort_by! { |s| s.tkt_credits_completed_year(@year) }

      i = 1
      @plot = []
      @students.each do |s|
        @plot << [i, s.tkt_credits_completed_year(@year).to_i, s.id]
        i += 1
      end

    elsif params[:order] == "math_credits_completed_year"
      @students.sort_by! { |s| s.math_credits_completed_year(@year).to_i }

      i = 1
      @plot = []
      @students.each do |s|
        @plot << [i, s.math_credits_completed_year(@year).to_i, s.id]
        i += 1
      end

    elsif params[:order] == "other_credits_completed_year"
      @students.sort_by! { |s| s.other_credits_completed_year(@year) }

      i = 1
      @plot = []
      @students.each do |s|
        @plot << [i, s.other_credits_completed_year(@year).to_i, s.id]
        i += 1
      end
    elsif params[:order] == "credits_completed_year"
      @students.sort_by! { |s| s.credits_completed_year(@year) }

      i = 1
      @plot = []
      @students.each do |s|
        @plot << [i, s.credits_completed_year(@year).to_i, s.id]
        i += 1
      end
    else
      raise
    end

    #i = 1
    #@plot = []
    #@group.students.each do |s|
    #  @plot << [i, s.credits_completed_year(@year).to_i, s.id]
    #  i += 1
    #end

  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(params[:group])

    if @group.save
      redirect_to @group, :notice => 'Group was successfully created.'
    else
      render :action => "new"
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update_attributes(params[:group])
      redirect_to @group, :notice => 'Group was successfully updated.'
    else
      render :action => "edit"
    end

  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
  end
end
