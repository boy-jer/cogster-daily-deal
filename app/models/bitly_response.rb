class BitlyResponse 
  CREDENTIALS ={ :username => 'cogsterdotcom', 
                 :key => 'R_f3c3acebd02571cbdfb8856167b9fbca' } 

  def self.short_url(url)
    client = Bitly::V3::Client.new(CREDENTIALS[:username], CREDENTIALS[:key])
    client.shorten(url).short_url
  end

end
