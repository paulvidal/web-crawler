require 'json'

class PageAssets

  def initialize(url, assets)
    @url = url
    @assets = assets
  end

  def url
    @url
  end

  def assets
    @assets
  end

  def to_json(*a)
    {:url => @url, :assets => @assets}.to_json(*a)
  end

end