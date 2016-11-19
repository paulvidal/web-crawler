# Client making calls to get the HTML of a page

class Client

  def initialize(log=FALSE)
    @connexion = init_connexion(log)
  end

  def get_page(url)
    @connexion.get(url).body
  end

  # Initialise faraday to follow url redirection and log all request on terminal
  def init_connexion(log=FALSE)
    Faraday.new do |faraday|
      if log
        faraday.response :logger
      end

      faraday.use FaradayMiddleware::FollowRedirects
      faraday.adapter Faraday.default_adapter
    end
  end

  private :init_connexion

end