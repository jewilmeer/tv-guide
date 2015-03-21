class Api::ProgramsController < Api::BaseController
  def index
    @programs = Program.order('status')
    @last_program = Program.order('updated_at').last

    if stale?(@last_program) do
      render json: @programs.where('name IS NOT NULL').pluck(:name)
    end
  end
end