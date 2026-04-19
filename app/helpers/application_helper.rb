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
  def time_of_day_greeting
    hour = Time.current.hour

    case hour
    when 5...12
      "Morning"
    when 12...17
      "Afternoon"
    when 17...21
      "Evening"
    else
      "Night"
    end
  end
end
