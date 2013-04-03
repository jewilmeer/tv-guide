require 'spec_helper'

describe NzbSearch do
  let(:instance) { NzbSearch.new }
  describe "link" do
    it "links to nzbindex.nl" do
      expect( instance.link ).to include 'http://nzbindex.nl/search/'
    end

    it "includes q as search term param" do
      expect( instance.link ).to include 'http://nzbindex.nl/search/'
    end

    it "includes minsize param with default 250MB" do
      expect( instance.link ).to include 'minsize=250'
    end

    it "includes hidespam param" do
      expect( instance.link ).to include 'hidespam=1'
    end

    it "includes complete param" do
      expect( instance.link ).to include 'complete=1'
    end
  end

  describe "age" do
    it "defaults to 10" do
      expect( instance.age ).to eql 10
    end

    it "reflexts changes to the link" do
      instance.age = 200
      expect( instance.link ).to include 'age=200'
    end
  end

  describe "search_terms" do
    it "defaults to empty" do
      expect( instance.search_terms ).to be_empty
    end

    it "reflexts changes to the link" do
      instance.search_terms = 'something'
      expect( instance.link ).to include 'q=something'
    end
  end
end