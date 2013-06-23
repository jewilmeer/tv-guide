require 'spec_helper'

describe User do
  describe 'create callbacks' do
    let(:user) { build(:user) }

    it "adds an authentication_token on creation" do
      expect { user.save! }.to change(user, :authentication_token).from(nil)
    end
  end
end
