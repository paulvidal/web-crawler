require_relative 'url_parser'

module StaticAssetsParser

  def StaticAssetsParser.find_static_assets(parsed_html, crawler)
    asset_links = []

    script_assets = parsed_html.css('script')
    script_assets.each do |script|
      asset_links << script['src']
    end

    link_assets = parsed_html.css('link')
    link_assets.each do |link|
      if link['rel'] == 'stylesheet'
        asset_links << link['href']
      end
    end

    images = parsed_html.css('img')
    images.each do |img|
      asset_links << img['src']
    end

    # Remove nils and local static files
    asset_links.reject! { |asset_link| !asset_link || asset_link.start_with?('//') }

    format_static_assets(asset_links, crawler)
  end

  def StaticAssetsParser.format_static_assets(assets, crawler)
    static_asset_urls = []

    assets.each do |asset|
      unless asset.start_with?('/')
        asset = '/' + asset
      end

      static_asset_url = crawler.base_url + asset
      static_asset_urls << static_asset_url
    end

    static_asset_urls
  end

end