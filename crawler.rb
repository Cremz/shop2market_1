# @class Crawler
class Crawler
  attr_accessor :url, :document, :pages, :level

  def initialize(url)
    @url = url
    @document = Nokogiri::HTML(open(@url))
    # set initial page to the inputed url
    @pages = [{ url: url, inputs: 0, parent: '' }]
    @level = 1
  end

  def crawl
    pages_clone = pages.clone

    while pages.length < 10 && @level < 3
      threads = []
      pages_clone.each do |page|
        threads << Thread.new do
          document = Nokogiri::HTML(open(page[:url]))

          # count number of inputs
          input_count = document.css('input').length
          add_inputs(input_count, page[:url])
          add_inputs(input_count, page[:parent]) unless page[:parent].empty?

          # go through all links on the page
          document.css('a').each do |href|
            link = href.attribute('href').to_s
            if link_is_good(link) && !pages.map { |x| x[:url] }.include?(link)
              pages << { url: link, inputs: 0, parent: page[:url] }
            end
            break if pages.length >= 50
          end
        end
      end
      threads.each(&:join)
      @level += 1
      pages_clone = pages - pages_clone
    end
  end

  def print_output
    puts pages.map { |page| "#{page[:url].sub(url, '')} - #{page[:inputs]} inputs" }
  end

  private

  def link_is_good(link)
    !link.empty? &&
      link.include?(url) &&
      link != url &&
      link.scan(/jpg|png|gif/).none? # raw check for file type
  end

  def add_inputs(input_count, url)
    pages.find { |page| page[:url] == url }[:inputs] += input_count
  end
end
