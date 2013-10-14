require 'streamer/sse'

class BuildsController < ApplicationController
  include ActionController::Live

  def index
    @project = Project.find(params[:project_id])
    @builds = Build.all.order(id: :desc).limit(5)
    @build = @project.builds.build
  end

  def create
    @project = Project.find(params[:project_id])
    @build = @project.builds.build(build_params)

    if @build.save
      redirect_to project_builds_path(@project), notice: 'Build was successfully created.' 
    else
      @builds = Build.all.order(id: :desc).limit(5)
      render action: 'index' 
    end
  end

  def show
    response.headers['Content-Type'] = 'text/event-stream'
      sse = Streamer::SSE.new(response.stream)
      redis = Redis.new(:host => '127.0.0.1', :port => 6379)
      redis.subscribe('build.data') do |on|
        on.message do |event, data|
          sse.write(data, event: 'build.data')
        end
      end
      render nothing: true
  rescue IOError
    # Client disconnected
  ensure
    redis.quit
    sse.close
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_build
    @build = Build.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def build_params
    params.require(:build).permit(:branch_name)
  end
end
