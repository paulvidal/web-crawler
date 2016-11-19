module UrlParser

  def UrlParser.find_urls(parsed_html, crawler)
    links = []

    anchor_tags = parsed_html.css('a')
    anchor_tags.each do |tag|
      links << tag['href']
    end

    add_formatted_urls(links, crawler)
  end

  def UrlParser.add_formatted_urls(links, crawler)
    base_url = crawler.base_url

    links.each do |link|

      if invalid_link?(link, crawler)
        next
      end

      if link.start_with?(crawler.url_scheme)
        add_url_if_new(link, crawler)

      else
        unless link.start_with?('/')
          link = '/' + link
        end

        full_link = base_url + link
        add_url_if_new(full_link, crawler)
      end

    end
  end

  # Helper functions
  def UrlParser.invalid_link?(link, crawler)
    begin
      !link || (link.start_with?(crawler.url_scheme) && URI.parse(link).host != crawler.url_host)
    rescue
      FALSE
    end
  end

  def UrlParser.add_url_if_new(url, crawler)
    if crawler.should_visit_url?(url)
      crawler.add_url_to_visit(url)
    end
  end

  def UrlParser.is_same_url(url1, url2)
    extract_path(url1) == extract_path(url2)
  end

  def UrlParser.extract_path(url)
    url.scan(/http[^?#]+/)[0]
  end

end