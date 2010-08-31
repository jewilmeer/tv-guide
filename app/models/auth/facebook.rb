class Auth::Facebook

  cattr_accessor :params

  def self.verify_call(params)
    @@params = params
  end
  
  def verify_params
    
  end
  
  def verify_string
    
  end
end