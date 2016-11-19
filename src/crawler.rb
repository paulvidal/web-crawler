require 'uri'
require 'faraday'
require 'faraday_middleware'
require 'nokogiri'
require 'json'
require_relative 'client'
require_relative 'url_parser'
require_relative 'page_assets'
require_relative 'static_assets_parser'

class Crawler

  def initialize(url, client=Client.new)
    parse_url = URI.parse(url)

    @client = client
    @url = url
    @url_scheme = parse_url.scheme
    @url_host = parse_url.host
    @page_assets_list = []
    @urls_to_visit = []
  end

  def url_scheme
    @url_scheme
  end

  def url_host
    @url_host
  end

  def base_url
    url_scheme + '://' + url_host
  end

  def crawl_and_print
    # Output to STDOUT the crawling results
    puts crawl
  end

  def crawl
    @urls_to_visit.push(@url)

    # While there are urls on the stack, continue visiting
    until @urls_to_visit.empty?
      url = @urls_to_visit.pop
      crawl_url(url)
    end

    @page_assets_list.to_json
  end

  def crawl_url(url)
    # Get the HTML from the page
    begin
      page_html = @client.get_page(url)
    rescue
      puts "Failed: #{url}"
      return
    end

    # Parse the HTML using Nokogiri
    parsed_html = Nokogiri::HTML(page_html)

    # Extract the static assets from the page
    assets = find_static_assets(parsed_html)
    @page_assets_list << PageAssets.new(url, assets)

    # Extract the urls from the page
    find_urls(parsed_html)
  end

  ## Parsing functions

  def find_urls(html)
    UrlParser.find_urls(html, self)
  end

  def find_static_assets(html)
    StaticAssetsParser.find_static_assets(html, self)
  end

  ## Urls managing functions

  def add_url_to_visit(url)
    @urls_to_visit.push(UrlParser.extract_path(url))
  end

  def should_visit_url?(url)
    @page_assets_list.select { |page_asset| UrlParser.is_same_url(page_asset.url, url) }.empty? \
    && @urls_to_visit.select { |url_to_visit| UrlParser.is_same_url(url_to_visit, url) }.empty?
  end

  private :crawl_url, :find_urls, :find_static_assets

end