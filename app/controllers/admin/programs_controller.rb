class Admin::ProgramsController < AdminAreaController
  before_filter :find_program, :except => [:index, :new, :create]
  # GET /admin_programs
  # GET /admin_programs.xml
  def index
    @programs = Program.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @programs }
    end
  end

  def show
    @default_configuration  = Configuration.first
    @configuration          = @program.configuration || @program.build_configuration(:filter_data => @default_configuration.filter_data)
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
  
  def find_program
    @program = Program.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @program
  end
end
