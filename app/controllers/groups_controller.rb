class GroupsController < ApplicationController

  def index
    @groups = Group.all.sort_by { |g| g.name }
    @keys = @groups.first.aggregate(2012).keys
  end

  def show
    @group = Group.find(params[:id])
    raise if params[:order].nil? or params[:year].nil?

    @year = params[:year].to_i

    @aggregate = {}
    (@group.start_year..2012).each do |y|
      @aggregate[y] = @group.aggregate y
    end

    @sorted = params[:order]
    @students = @group.students.sort_by! { |s| s.send(@sorted, (@year)) }

    i = 1
    @plot = []
    @students.each do |s|
      @plot << [i, s.send(@sorted, (@year)).to_i, s.id]
      i += 1
    end

  end

  def path
    @group = Group.find(params[:id])

    if stale?(:last_modified => @group.updated_at.utc, :etag => @group)

      students = @group.students.inject([]) { |set, s| set << s.progress }

      if not Rails.cache.exist? "#{@group.name} paths"
        plot = []
        (1..@group.students.first.months_studied).each do |m|
          row = [m]
          students.each do |s|
            row << s[m-1]
          end
          plot << row.to_s.chop[1..-1]
        end
        Rails.cache.write "#{@group.name} paths", plot
      end

      @plot = Rails.cache.read "#{@group.name} paths"

    end

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
