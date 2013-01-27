require 'spec_helper'

class Example
  include Concerns::Authentication
end
describe Concerns::Authentication do
  describe "require_trust" do
    subject { klass_instance.require_trust }
    let(:klass_instance) { Example.new }

    it "raises when not logged in" do
      klass_instance.stub(:current_user) { nil }
      expect{subject}.to raise_error(AccessDenied)
    end

    it "raises when not trusted" do
      user = double(:user, trusted?: false)
      klass_instance.stub(current_user: user)
      expect{subject}.to raise_error(AccessDenied)
    end

    it "allows when trusted" do
      user = double(:user, trusted?: true)
      klass_instance.stub(current_user: user)
      expect{subject}.to be_true
    end
  end

  describe "require_admin" do
    subject { klass_instance.require_admin }
    let(:klass_instance) { Example.new }

    it "raises when not logged in" do
      klass_instance.stub(:current_user) { nil }
      expect{subject}.to raise_error(AccessDenied)
    end

    it "raises when not trusted" do
      user = double(:user, admin?: false)
      klass_instance.stub(current_user: user)
      expect{subject}.to raise_error(AccessDenied)
    end

    it "allows when trusted" do
      user = double(:user, admin?: true)
      klass_instance.stub(current_user: user)
      expect{subject}.to be_true
    end
  end
end