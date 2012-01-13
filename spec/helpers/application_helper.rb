require 'spec_helper'

describe ApplicationHelper do
  describe "pretty_user_agent" do
    subject { helper.formatted_user_agent agent_string }

    context "without user agent" do
      let(:agent_string) { '' }
      it { should be_nil }
    end

    context "with chrome browser" do
      let(:agent_string) { 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/535.7 (KHTML, like Gecko) Chrome/16.0.912.75 Safari/535.7' }
      it { should eql 'Chrome 16.0.912.75 (OS X 10.7)' }
    end

    context "with older firefox browser" do
      let(:agent_string) { 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.7; en-US; rv:1.9.2.17) Gecko/20110420 Firefox/3.6.17' }
      it { should eql 'Firefox 3.6.17 (OS X 10.7)' }
    end

    context "with modern firefox browser" do
      let(:agent_string) { 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0) Gecko/20100101 Firefox/10.0' }
      it { should eql 'Firefox 10.0 (OS X 10.7)' }
    end

    context "with sabnzb" do
      let(:agent_string) { 'SABnzbd+/0.6.10' }
      it { should eql 'SABnzbd+ 0.6.10' }
    end

    context "with unknown browser" do
      let(:agent_string) { 'lorem ipsum' }
      it { should eql 'unknown user agent' }
    end
  end
end