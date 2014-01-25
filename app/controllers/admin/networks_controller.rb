class Admin::NetworksController < AdminAreaController
  def index
    @networks = Network.order('programs_count desc, name')
  end

  def show
    @network = Network.find(params[:id])
    program_scope = @network.programs.order('active desc, status, first_aired desc')
    @programs = program_scope.section params[:page]
    @next_programs = program_scope.section params[:page].to_i.succ
  end

  def destroy
    @network = Network.find(params[:id])
    @network.destroy

    redirect_to admin_networks_path
  end
end