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

  def destroy
    @genre = Genre.find(params[:id])
    @genre.destroy

    redirect_to admin_genres_path
  end
end