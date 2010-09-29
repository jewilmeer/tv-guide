class ImagesController < ApplicationController
  def show
    @image = Image.find(params[:id])
    
    render :inline => "@image.operate", :type => :flexi
  end
end