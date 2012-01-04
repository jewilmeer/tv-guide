class Admin::ProgramsController < AdminAreaController
  helper_method :sort_column, :sort_direction
  before_filter :find_program, :except => [:index, :new, :create]

  # GET /admin_programs
  # GET /admin_programs.xml
  def index
    @programs = Program.by_status.order(sort_column + ' ' + sort_direction)#.paginate :per_page => 22, :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @programs }
      format.js   { render :text => render_to_string( @programs ) }
    end
  end

  def show
    @default_configuration  = ::Configuration.first
    @configuration          = @program.configuration || @program.build_configuration(:filter_data => @default_configuration.filter_data)
    @last_episode           = @program.episodes.airdate_in_past.last
    @nav = {
      :next     => Program.limit(1).order('name desc').where('name > ?', @program.name).first,
      :previous => Program.limit(1).order('name asc').where('name > ?', @program.name).first
    }
  end

  # GET /admin_programs/new
  # GET /admin_programs/new.xml
  def new
    @program = Program.new
  end

  # GET /admin_programs/1/edit
  def edit
  end

  # POST /admin_programs
  # POST /admin_programs.xml
  def create
    @program = Program.new(params[:program])

    respond_to do |format|
      if @program.save
        format.html { redirect_to(@program, :notice => 'Program was successfully created.') }
        format.xml  { render :xml => @program, :status => :created, :location => @program }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_programs/1
  # PUT /admin_programs/1.xml
  def update
    respond_to do |format|
      if @program.update_attributes(params[:program])
        format.html { redirect_to([:admin, @program], :notice => 'Program was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @program.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_programs/1
  # DELETE /admin_programs/1.xml
  def destroy
    @program.destroy

    respond_to do |format|
      format.html { redirect_to(admin_programs_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def find_program
    @program = Program.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @program
  end
  
  def sort_column
    Program.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
