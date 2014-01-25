class Admin::GenresController < AdminAreaController
  def index
    @genres = Genre.order(:name)
  end

  def show
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    @genre.update_attribute :active, params[:active]
  end
end