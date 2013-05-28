module Admin::ApplicationHelper
  def active_page? controller
    controller == params[:controller]
  end
end