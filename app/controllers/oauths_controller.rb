class OauthsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def client
    OAuth2::Client.new(APP_CONFIG[:facebook]['app_id'], APP_CONFIG[:facebook]['app_secret'], :site => 'https://graph.facebook.com')
  end

  def start
    
  end
  
  def callback
    access_token = client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
    user = JSON.parse(access_token.get('/me'))
    
    logger.debug ""*20
    logger.debug params.inspect
    logger.debug ""*20
    logger.debug user.inspect
    logger.debug ""*20
    logger.debug ""*20
    
    render :text => 'ok'
  end
  
  def destroy
    logger.debug params.inspect
    render :text => 'ok'
  end
  
  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/oauth/callback'
    uri.query = nil
    uri.to_s
  end
  
end