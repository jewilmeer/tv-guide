class Api::ProgramsController < Api::BaseController
  def index
    @programs = Program.order('status')

    # render json: @programs
    render json: @programs.where('name IS NOT NULL').pluck(:name)
  end
end