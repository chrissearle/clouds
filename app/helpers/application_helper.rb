module ApplicationHelper
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
end
