class ImagesController < ApplicationController
  before_filter :get_object
  def show
    if @image.image?
      redirect_to @image.s3_url( :episode )
    else
      require 'open-uri'
      logger.debug "opening #{@image.url}"
      send_file open(@image.url), :disposition => 'inline', :type => :jpg
    end
  rescue OpenURI::HTTPError
    @image.destroy
    render :gone
  end
  
  def update
    if params[:save]
      @image.save_image
      @image.save!
    end
    respond_to do |format|
      format.js { @image_template = render_to_string(:partial => '/images/image', :locals => {:image => @image}).html_safe }
      format.jpg { render :nothing => true }
    end
  end
  
  def get_object
    @image = Image.find(params[:id])
  end
end