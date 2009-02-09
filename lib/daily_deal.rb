require "rubygems"
require "hpricot"
require "open-uri"
require "ostruct"
require "guid"
require "builder"

module DailyDeal
  class << self
    def parse(contents)
      doc = Hpricot(contents) / ".bookdetails"
      result = OpenStruct.new
      result.title = (doc/"h3"/"a").first.innerText
      result.description = (doc/"p").to_html
      result.cover_image = "http://www.apress.com" + (doc/".cover"/"img").first[:src]
      result
    end

    def rss(result)
      xml = Builder::XmlMarkup.new :indent => 2
      xml.instruct!
      xml.rss :version => '2.0', "xmlns:atom" => "http://www.w3.org/2005/Atom" do
        xml.channel do
          xml.title "Apress Deal of the Day"
          xml.description "Apress Deal of the Day"
          deal_link = "http://www.apress.com/info/dailydeal"
          xml.link deal_link
          xml.tag! "atom:link", :rel => "self", :href => "http://www.patmaddox.com/apress_daily_deal.rss"

          xml.item do
            xml.title result.title
            xml.description "<p><img src='#{result.cover_image}'/></p>#{result.description}"
            xml.link deal_link
            xml.pubDate DateTime.now.rfc822
            xml.guid Guid.new.to_s, :isPermaLink => false
          end
        end
      end
    end

    def fetch
      rss parse(open("http://www.apress.com/info/dailydeal"))
    end
  end
end

class DateTime
  def rfc822
    strftime '%a, %d %b %Y %H:%M:%S %z'
  end
end
