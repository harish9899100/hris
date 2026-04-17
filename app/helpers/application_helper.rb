module ApplicationHelper
  def status_badge(status)
    case status.to_s
    when "active"
      "<span class='badge badge--green'>Active</span>".html_safe
    when "on_leave"
      "<span class='badge badge--amber'>On Leave</span>".html_safe
    when "terminated"
      "<span class='badge badge--red'>Terminated</span>".html_safe
    else
      "<span class='badge'>#{status}</span>".html_safe
    end
  end
end
