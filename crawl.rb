#!/usr/bin/env ruby

require_relative 'src/crawler'

## Main program ##

unless ARGV.length == 1
  puts 'Usage: ruby crawler [url]'
  exit 1
end

url = ARGV[0]

# Check if url valid
if url !~ URI::regexp
  puts "Invalid url: #{url}"
  exit 1
end

Crawler.new(url).crawl_and_print