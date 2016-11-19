require 'json'
require_relative '../src/crawler'

describe Crawler do

  URL = "https://gocardless.com/"
  HTML_1 =
      "<html>
        <head>
          <title>A Simple HTML Document</title>
          <link rel=\"stylesheet\" href=\"/bundle/styling.css\">
        </head>
        <body>
          <img src=\"clouds.jpg\">
          <a href=\"https://gocardless.com/pricing\">Link Name</a>
          <p>This is a very simple HTML document</p>
          <p>It only has two paragraphs</p>
        </body>
      </html>"

  HTML_2 =
      "<html>
        <head>
          <title>A Simple HTML Document</title>
        </head>
        <body>
          <a href=\"https://gocardless.com/why_you_will_love_it\">Link Name</a>
          <p>This is a very simple HTML document</p>
          <p>It only has two paragraphs</p>
          <a href=\"https://gocardless.com/pricing\">Link Name</a>
          <a href=\"https://gocardless.com/blog\">Link Name</a>
          <a href=\"https://gocardless.com/best_company_ever\">Link Name</a>
        </body>
      </html>"

  describe "#crawl" do

    it 'should create the right base url' do
      expect(Crawler.new('https://gocardless.com/pricing').base_url).to eq('https://gocardless.com')
      expect(Crawler.new('https://gocardless.com/blog?some_param=1').base_url).to eq('https://gocardless.com')
    end

    it 'should crawl one url and get static assets' do
      client_double = instance_double(Client, :get_page => HTML_1)
      crawler = Crawler.new(URL, client_double)

      page_assets = [PageAssets.new('https://gocardless.com/', ['https://gocardless.com/bundle/styling.css', 'https://gocardless.com/clouds.jpg']),
                     PageAssets.new('https://gocardless.com/pricing', ['https://gocardless.com/bundle/styling.css', 'https://gocardless.com/clouds.jpg'])]
      expect(crawler.crawl).to eq(page_assets.to_json)
    end

    it 'should crawl multiple pages' do
      client_double = instance_double(Client, :get_page => HTML_2)
      crawler = Crawler.new(URL, client_double)

      page_assets = [PageAssets.new('https://gocardless.com/', []),
                     PageAssets.new('https://gocardless.com/best_company_ever', []),
                     PageAssets.new('https://gocardless.com/blog', []),
                     PageAssets.new('https://gocardless.com/pricing', []),
                     PageAssets.new('https://gocardless.com/why_you_will_love_it', [])]

      expect(crawler.crawl).to eq(page_assets.to_json)
    end

  end

end