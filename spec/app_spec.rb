require 'spec_helper.rb'
require 'nokogiri'
describe Crawler do
  def app
    @app ||= Crawler
  end
  let(:crawler) { Crawler.new('./spec/fixture.html')}
  describe 'link_is_good' do
    it 'should return false for empty link' do
      expect(crawler.send(:link_is_good, '')).to be_falsey
    end
    it 'should return true for link that doesn\'t match' do
      expect(crawler.send(:link_is_good, './spec/fixture.html/?something')).to be_truthy
    end
    it 'should return false for link that matches url' do
      expect(crawler.send(:link_is_good, './spec/fixture.html')).to be_falsey
    end
    it 'should return false for link that is an image' do
      expect(crawler.send(:link_is_good, './spec/fixture.jpg')).to be_falsey
    end
  end

  describe 'add inputs' do
    it 'should update input counter' do
      crawler.send(:add_inputs, 10, './spec/fixture.html')
      expect(crawler.pages).to eq [{:url=>"./spec/fixture.html", :inputs=>10, :parent=>""}]
    end
  end
  describe 'print output' do
    it 'should print formated input' do
      expect{ crawler.print_output}.to output(" - 0 inputs\n").to_stdout
    end
    it 'should print formated input after increased count' do
      crawler.send(:add_inputs, 10, './spec/fixture.html')
      expect{ crawler.print_output}.to output(" - 10 inputs\n").to_stdout
    end
  end

  describe 'run crawler' do
    it 'should crawl the webpage' do
      crawler.stub(:link_is_good).and_return(true)
      crawler.crawl
      expect(crawler.pages).to eq [{:url=>"./spec/fixture.html", :inputs=>4, :parent=>""}, {:url=>"http://www.shop2market.com/contact", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"https://login.shop2market.com/login", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"mailto:", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://shop2market.com", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://shop2market.com/technologie/", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://shop2market.com/consultancy/", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://shop2market.com/blog/", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://shop2market.com/over-ons/", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://shop2market.com/author/admin/", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://adcurve.de.webhosting67.transurl.nl/wp-content/uploads/2014/11/John-Wanamaker.jpeg", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"#", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"www.shop2market.com/technologie/", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"www.shop2market.com/consultancy", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://www.kijkshop.nl/", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"https://www.alternate.nl", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://www.hunkemoller.nl/", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://t.co/GkFhtYu1BU", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://twitter.com/shop2market/statuses/613668228741636096", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://t.co/U08BOyed7n", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://twitter.com/shop2market/statuses/610705842166439936", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://twitter.com/ksvanderaa", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://t.co/s6YSMcNxrG", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://twitter.com/shop2market/statuses/608529127830880256", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"www.facebook.com/shop2market", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"https://twitter.com/shop2market", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"youtube.com/shop2market", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"https://www.linkedin.com/company/800670?trk=tyah&trkInfo=clickedVertical%3Acompany%2Cidx%3A3-1-7%2CtarId%3A1436347226580%2Ctas%3Ashop2", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"mailto:info@shop2market.com", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://www.shop2market.com", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://shop2market.com/terms-conditions", :inputs=>0, :parent=>"./spec/fixture.html"}, {:url=>"http://shop2market.com/privacy-policy", :inputs=>0, :parent=>"./spec/fixture.html"}]
    end
  end
end
