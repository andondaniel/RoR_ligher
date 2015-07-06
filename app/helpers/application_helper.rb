module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def application_error_messages!
    messages = ""
    class_css = "success"
    flash.each do |name, msg|
      class_css = "error" if name.to_s.eql?("alert")
      if msg.class == Array
        messages = msg.map { |me| content_tag :li, me }.join
      else
        messages = content_tag :li, msg
      end
    end

    flash.discard(:alert)
    flash.discard(:notice)

    unless messages.blank?
      html = <<-HTML
      <div class="alert_message #{class_css}">
        #{messages}
      </div>
      HTML

      return html.html_safe
    else
      return nil
    end
  end

end
