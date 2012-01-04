class Admin::ImagesController < AdminAreaController
  before_filter :get_program

  def index
    if @program
      @images = @program.images
    else
      @images = Image.order('updated_at desc').limit(20)
    end
  end

  def show
    @image = Image.find params[:id]
  end

  def get_program
    return unless params[:program_id]

    @program = Program.find params[:program_id]
  end
end