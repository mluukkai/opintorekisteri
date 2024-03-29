class GroupsController < ApplicationController
  caches_action :index

  def index
    @groups = Group.all.sort_by { |g| g.name }
    @keys = @groups.first.aggregate(2012).keys

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => form_answer }
    end
  end

  def form_answer
    v = {}
    v[:groups] = @groups
    v[:keys] = @keys
    v
  end

  def touch
    expire_action :action => :index

    redirect_to :action => :index
  end

  def show
    @group = Group.find(params[:id])
    raise if params[:order].nil? or params[:year].nil?

    if stale?(:last_modified => @group.updated_at.utc, :etag => @group)

      @year = params[:year].to_i

      if not Rails.cache.exist? "#{@group.name} stats"
        aggregate = {}
        (@group.start_year..Group.current_year).each do |y|
          aggregate[y] = @group.aggregate y
        end
        Rails.cache.write "#{@group.name} stats", aggregate
      end
      @aggregate = Rails.cache.read "#{@group.name} stats"

      @sorted = params[:order]
      @students = @group.students.sort_by! { |s| s.send(@sorted, (@year)) }

      i = 1
      @plot = []
      @students.each do |s|
        @plot << [i, s.send(@sorted, (@year)).to_i, s.id]
        i += 1
      end

    end

  end

  def path
    @group = Group.find(params[:id])

    if stale?(:last_modified => @group.updated_at.utc, :etag => @group)

      if not Rails.cache.exist? "#{@group.name} paths"
        students = @group.students.inject([]) { |set, s| set << s.progress }
        plot = (1..@group.students.first.months_studied).inject([]) do |set, m|
          row = [m]
          students.each do |s|
            row << s[m-1]
          end
          set << row.to_s.chop[1..-1]
        end
        Rails.cache.write "#{@group.name} paths", plot
      end

      @plot = Rails.cache.read "#{@group.name} paths"

    end

    @map = []
    i = 1
    @group.students.each do |s|
      @map << [i, s.id]
      i+=1
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
