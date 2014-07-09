class PointsController < ApplicationController
  before_filter :get_points, :except => [:show, :current, :create]

  def index
  end

  def new
    @point = Point.new
    @point.name = 'New Point'
    @point.privacy_flag = true
  end

  def create
    point = Point.new(point_params)
    point.user = current_user

    redirect_to current_url(point.latitude, point.longitude)
  end

  def show
    begin
      @point = Point.find(params[:id])

      unless @point.privacy_flag?
        redirect_to :action => :index, notice: 'Not Found'
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to :action => :index, notice: 'Not Found'
    end
  end

  def current
    @point = Point.new

    @point.name = "Latitude #{params[:lat].to_f.round(5)} - Longitude - #{params[:lng].to_f.round(5)}"
    @point.latitude = params[:lat]
    @point.longitude = params[:lng]
    @point.privacy_flag = true
  end

  private

  def get_points
    @points = Point.published.ordered
  end

  def point_params
    params.require(:point).permit(:name, :latitude, :longitude, :privacy_flag)
  end

end
