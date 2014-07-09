module ApplicationHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def bootstrap_type(type)
    case type
      when :alert
        'warning'
      when :error
        'danger'
      when :notice
        'info'
      when :success
        'success'
      else
        type.to_s
    end
  end

  def link_with_icon(icon, text, white=false)
    "<span class='glyphicon glyphicon-#{icon} #{'white' if white}'></span>&nbsp;#{text}".html_safe
  end

  def js_map_url
    params = { 'sensor' => false }

    unless ENV['GOOGLE_API_KEY'].blank?
      params['key'] = ENV['GOOGLE_API_KEY']
    end

    return ('http://maps.google.com/maps/api/js?' + params.map{|k,v| "#{k}=#{v}"}.join('&')).html_safe
  end

  def static_map_for_point(point)
    params = "center=#{point.latitude},#{point.longitude}&size=200x70&zoom=10&markers=size:small|color:red|#{point.latitude},#{point.longitude}&sensor=false"

    params.gsub!("|", "%7C")

    unless ENV['GOOGLE_API_KEY'].blank?
      params = params + "&key=#{ENV['GOOGLE_API_KEY']}"
    end

    "http://maps.google.com/maps/api/staticmap?#{params}".html_safe
  end

  def streetview_image(point, wide=false)
    size = '200x70'
    css = 'streetview'

    if wide
      size = '280x100'
      css = 'streetview wide'
    end

    image_tag(streetview_map_for_point(point, size))
  end

  def streetview_map_for_point(point, size)
    params = "location=#{point.latitude},#{point.longitude}&size=#{size}&sensor=false"

    unless ENV['GOOGLE_API_KEY'].blank?
      params = params + "&key=#{ENV['GOOGLE_API_KEY']}"
    end

    "http://maps.googleapis.com/maps/api/streetview?#{params}".html_safe
  end

  def location_for_point(point)
    "#{point.latitude.round(5)}, #{point.longitude.round(5)}".html_safe
  end
end
