module ApplicationHelper

  def title page_title
    content_for(:title) { page_title }
  end

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        'alert-success'
      when :error
        'alert-error'
      when :alert
        'alert-block'
      when :notice
        'alert-success'
      else
        flash_type.to_s
    end
  end

end
