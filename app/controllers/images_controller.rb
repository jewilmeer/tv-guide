class ImagesController < ApplicationController
  before_filter :get_object
  def show
    if @image.image? #questionmark is very important, otherwise will return a string, which equals true
      redirect_to @image.s3_url( :episode )
    else
      require 'open-uri'
      send_file open(@image.url), :disposition => 'inline', :type => :jpg
    end
  rescue OpenURI::HTTPError
    @image.destroy
    render :status => :gone
  end
  
  def update
    if params[:save]
      @image.update_image
    end
    respond_to do |format|
      # format.js { @image_template = render_to_string(:partial => '/images/image', :locals => {:image => @image}).html_safe }
      format.js { }
      format.jpg { render :nothing => true}
    end
  end
  
  def get_object
    @image = Image.find(params[:id])
  end
end