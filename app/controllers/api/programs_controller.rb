class Api::ProgramsController < Api::BaseController
  def index
    @programs = Program.order('status')

    # render json: @programs
    render json: @programs.pluck(:name)
  end
end