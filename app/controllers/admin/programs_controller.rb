class Admin::ProgramsController < ApplicationController
  # GET /admin_programs
  # GET /admin_programs.xml
  def index
    @admin_programs = Admin::Program.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_programs }
    end
  end

  # GET /admin_programs/1
  # GET /admin_programs/1.xml
  def show
    @program = Admin::Program.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @program }
    end
  end

  # GET /admin_programs/new
  # GET /admin_programs/new.xml
  def new
    @program = Admin::Program.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @program }
    end
  end

  # GET /admin_programs/1/edit
  def edit
    @program = Admin::Program.find(params[:id])
  end

  # POST /admin_programs
  # POST /admin_programs.xml
  def create
    @program = Admin::Program.new(params[:program])

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
    @program = Admin::Program.find(params[:id])

    respond_to do |format|
      if @program.update_attributes(params[:program])
        format.html { redirect_to(@program, :notice => 'Program was successfully updated.') }
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
    @program = Admin::Program.find(params[:id])
    @program.destroy

    respond_to do |format|
      format.html { redirect_to(admin_programs_url) }
      format.xml  { head :ok }
    end
  end
end
