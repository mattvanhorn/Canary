class BlackHoleStore
  def logger
    Rails.logger
  end
  
  def fetch( *args )
    yield
  end
  
  def read( *args )
  end
  
  def write( *args )
  end
  
  def delete( *args )
  end
  
  def increment( *args )
  end
  
  def decrement( *args )
  end
end