require 'nokogiri'
require 'awesome_print'
require 'active_support/core_ext/hash/conversions'
require 'open-uri'
require 'net/http'

class Crawler
  attr_accessor :url, :document, :pages, :level
  def initialize(url)
    @url = url
    @document = Nokogiri::HTML(open(@url))
    @pages = [{url: url, inputs: 0, parent: ''}]
    @level = 1
  end

  def link_is_good(link)
    !link.empty? &&
    link.include?(url) &&
    link != url &&
    link.scan(/jpg|png|gif/).none? # raw check for file type
    #&&
    # open(link).content_type == "text/html"
  end

  def crawl
    pages_clone = pages.clone
    while pages.length < 10 && @level < 3

      pages_clone.each do |page|
          document = Nokogiri::HTML(open(page[:url]))

          # count number of inputs
          input_count = document.css('input').length
          add_inputs(input_count, page[:url])
          add_inputs(input_count, page[:parent]) unless page[:parent].blank?

          # go through all links on the page
          document.css('a').each do |href|
            link = href.attribute('href').to_s
            if link_is_good(link) && !pages.map{|x| x[:url]}.include?(link)
              pages << {url: link, inputs: 0, parent: page[:url] }
            end
            break if pages.length >= 50
          end
      end

      @level += 1
      pages_clone = pages - pages_clone

    end
  end
  def add_inputs(input_count, url)
    pages.select {|page| page[:url] == url}.first[:inputs] += input_count
  end
  def print_output
    pages.each {|x| puts "#{x[:url].sub(url,'')} - #{x[:inputs]} inputs" }
  end
end
puts 'Input the website you want to crawl:'

url = gets.strip
if url.blank? || !url.include?('http') || open(url).content_type != 'text/html'
  puts 'Invalid url, using default url'
  url = "http://shop2market.com"
  puts url
end

initial_time = Time.now
c = Crawler.new(url)
c.crawl
c.print_output
puts "Finished in #{Time.now - initial_time} seconds"
