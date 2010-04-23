class Admin::PagesController < AdminAreaController

  # admin homepage
  def root
  end

  def index
    @pages = Page.all
  end
end