class UriParser
  require 'open-uri'

  def initialize(tld,path,css_path)
    @tld = tld
    @path = path
    @css_path = css_path
  end

  def parse
    extract_elements.collect { |element| "#{@tld}/#{element.attribute('href').value}" }
  end

  private 

  def extract_elements
    doc = Nokogiri::HTML(open(uri))
    @css_path.split(' ').inject(doc) do |elements,css|
      elements.css(css)
    end
  end

  def uri
    "#{@tld}/#{@path}"
  end
end
