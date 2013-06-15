class PathsController < ApplicationController

  def index
    @paths = Path.all
  end

  def show
    @path = Path.find(params[:id])

    if stale?(:last_modified => @path.updated_at.utc, :etag => @path)

      if not Rails.cache.exist? "#{@path.started}paths"
        path_map = []
        @path.groups.each do |group|
          students = group.students.inject([]) { |set, s| set << s.progress }
          plot = (1..group.students.first.months_studied).inject([]) do |set, m|
            row = [m]
            students.each do |s|
              row << s[m-1]
            end
            set << row.to_s.chop[1..-1]
          end
          path_map << plot
        end
        Rails.cache.write "#{@path.started}paths", path_map
      end

      @plots = Rails.cache.read "#{@path.started}paths"

      @max = (@plots.flatten.to_s.gsub(/\"/, '').gsub(/\[/, '').gsub(/\]/, '')).split(',').map { |e| e.to_i }.max

      @groups = @path.groups.inject([]) do |set, g|
        set << g.name
      end

    end
  end

  def new
    @path = Path.new
  end

  def edit
    @path = Path.find(params[:id])
  end

  def create
    @path = Path.new(params[:path])

    if @path.save
      redirect_to @path, :notice => 'Path was successfully created.'
    else
      render :action => "new"
    end
  end
end

def update
  @path = Path.find(params[:id])

  if @path.update_attributes(params[:path])
    redirect_to @path, :notice => 'Path was successfully updated.'
  else
    render :action => "edit"
  end
end


def destroy
  @path = Path.find(params[:id])
  @path.destroy
end

