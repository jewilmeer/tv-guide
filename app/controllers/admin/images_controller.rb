class Admin::ImagesController < AdminAreaController
  def index
    @program = get_program
    @images = @program.images
    @nav = program_nav_links
  end

  private
  def get_program
    Program.find params[:program_id]
  end
end