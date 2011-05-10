class User::ProgramsController < UserAreaController
  before_filter :require_trust, :only => :aired
  def create
    if params[:id]
      current_user.programs << @program = Program.find(params[:id])
    else
      @program = current_user.programs.build(:tvdb_id => params[:tvdb_id])
      if @program.valid?
        
        begin
          #some logic
          @program.save!
        rescue ActiveRecord::RecordNotSaved => e
          logger.debug @program.errors.full_messages
        end
        
        # @program.save!
      else
        logger.debug @program.errors.full_messages.inspect
      end
      # @program = Program.find_or_create_by_name(params[:name])
      # raise ActiveRecord::RecordNotFound unless @program
      # current_user.programs << @program
    end
    @program.touch # Expire cache keys
    respond_to do |format|
      format.html do
        flash[:notice] = 'Program added!'
        redirect_to :back
      end
      format.js {}
    end
  end
  
  def index
    @programs          = @user.programs.by_name
    basic_episodes     = Episode.watched_by_user(@user.programs)
    @upcoming_episodes = basic_episodes.by_airs_at.airs_at_after(Time.now).limit(20)
    @past_episodes     = basic_episodes.by_airs_at(:desc).airs_at_before(Time.now).includes(:downloads).limit(20)
    @program_cache_key = @user.programs.by_updated_at.last
    # response.headers['Cache-Control'] = "public, max-age=#{5.minutes.seconds}" if Rails.env.production?
  end

  def aired
    @episodes           = Episode.watched_by_user(@user.programs).airs_at_in_past.downloaded.by_airs_at(:desc).limit(30).includes(:program)
  end
  
  def destroy
    current_user.programs.delete(Program.find(params[:id]))
    current_user.programs.first.touch #expire cache
    flash[:notice] = 'Program removed'
    redirect_to :back
  end
end