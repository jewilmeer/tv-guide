class Admin::ConfigurationsController < AdminAreaController
  before_filter :find_configuration, :except => [:index, :new, :create]

  def index
    @configurations = ::Configuration.all(:include => :program)
  end

  def new
    @configuration = ::Configuration.new
  end
  
  def create
    @config = ::Configuration.new(params[:configuration])
    if (filter_data = eval(params[:configuration][:filter_data])).is_a?(Hash)
      @config.filter_data = filter_data
    end
    @config.save!
    flash[:notice] = "filter added"
    redirect_to :back
  end
  
  def edit
  end
  
  def update
    if (filter_data = eval(params[:configuration][:filter_data])).is_a?(Hash)
      @configuration.filter_data = filter_data
    end
    @configuration.save!
    redirect_to :back
  end
  
  def destroy
    if ::Configuration.default == @configuration
      redirect_to [:admin, :configurations], :alert => "Configuration could not be removed" 
      return
    end
    @configuration.destroy
    redirect_to [:admin, :configurations], :notice => "Configuration Removed"
  end
    
  protected
  def find_configuration
    @configuration = ::Configuration.find(params[:id])
  end
end
