require 'nokogiri'
require 'open-uri'
require 'net/http'
require './crawler.rb'

puts 'Input the website you want to crawl:'

url = gets.strip
if url.empty? || !url.include?('http') || open(url).content_type != 'text/html'
  puts 'Invalid url, using default url'
  url = 'http://shop2market.com/'
  puts url
end

initial_time = Time.now
c = Crawler.new(url)
c.crawl
c.print_output
puts "Found #{c.pages.length} pages."
puts "Finished in #{Time.now - initial_time} seconds."
