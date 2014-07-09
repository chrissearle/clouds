class PointsController < ApplicationController
  before_filter :get_points, :except => [:show, :current, :create]
  before_filter :get_point, :only => [:show, :streetview]

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
  end

  def current
    @point = Point.new

    @point.name = "Latitude #{params[:lat].to_f.round(5)} - Longitude - #{params[:lng].to_f.round(5)}"
    @point.latitude = params[:lat]
    @point.longitude = params[:lng]
    @point.privacy_flag = true
  end

  def streetview
    uri = URI.parse(@point.streetview_url('300x100'))

    http = Net::HTTP.start(uri.host)

    resp = http.head("#{uri.path}?#{uri.query}")

    size = resp['content-length']

    http.finish

    render json: { :available => (size.to_i != 2914), :image => uri.to_s }
  end

  private

  def get_point
    if (current_user)
      @point = current_user.points.find(params[:id])
    else
      @point = Point.find(params[:id])

      unless @point.privacy_flag
        raise ActiveRecord::RecordNotFound
      end
    end

  end

  def get_points
    if (current_user)
      @points = current_user.points.ordered
    else
      @points = Point.published.ordered
    end
  end

  def point_params
    params.require(:point).permit(:name, :latitude, :longitude, :privacy_flag)
  end

end
