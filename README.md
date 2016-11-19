# Web Crawler

A single-threaded web crawler that extracts static asset's urls (linked to the domain) from pages it visits.

Output displayed in the terminal in the following json format:

```json
[
  {
    "url": "http://www.example.org",
    "assets": [
      "http://www.example.org/image.jpg",
      "http://www.example.org/script.js"
    ]
  },
  {
    "url": "http://www.example.org/about",
    "assets": [
      "http://www.example.org/company_photo.jpg",
      "http://www.example.org/script.js"
    ]
  }
]
```

**Installation instructions**

1) Install bundler (skip step if already done)

```shell
gem install bundler
```

2) Run Bundle install in root folder (web-crawler) to install all ruby dependencies

```shell
bundle install
```

3) Run the program crawl.rb (Require version of ruby >= 2)

```shell
ruby crawl.rb [url]
```

**Run tests**

```shell
bundle exec rspec
```