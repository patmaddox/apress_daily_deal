require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))

module DailyDeal
  describe PageParser do
    before(:each) do
      contents = File.read(File.join(File.dirname(__FILE__), 'resources', 'unite_the_tribes.html'))
      @result = PageParser.parse(contents)
    end

    it "should get the title" do
      @result.title.should == "Unite the Tribes: Ending Turf Wars for Career and Business Success"
    end

    it "should get the description" do
      @result.description.should include("No matter what business", "When you reach people")
    end

    it "should get the cover image" do
      @result.cover_image.should == "http://www.apress.com/resource/bookcover/tribes.jpg"
    end
  end
end
