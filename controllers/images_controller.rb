class ImagesController < ApplicationController
  def show
    @image = Image.find(params[:id])

    require 'open-uri'
    send_file open(@image.url), :disposition => 'inline', :type => :jpg
  end
end