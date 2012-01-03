class Admin::ImagesController < AdminAreaController
  def index
    @images = Image.limit(20).order('updated_at desc').all
  end

  def show
    @image = Image.find params[:id]
  end
end