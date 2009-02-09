require "rubygems"
require "hpricot"
require "open-uri"
require "ostruct"

module DailyDeal
  class PageParser
    def self.parse(contents)
      doc = Hpricot(contents) / ".bookdetails"
      result = OpenStruct.new
      result.title = (doc/"h3"/"a").first.innerText
      result.description = (doc/"p").to_html
      result.cover_image = "http://www.apress.com" + (doc/".cover"/"img").first[:src]
      result
    end
  end
end
