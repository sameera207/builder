module ApplicationHelper
  def  format_date_time dt
    dt.strftime("%m/%d/%Y %I:%M")
  end
end
