require 'spec_helper'

describe User do
  describe 'create callbacks' do
    let(:user) { build(:user) }

    it "adds an authentication_token on creation" do
      expect { user.save! }.to change(user, :authentication_token).from(nil)
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  email                :string(255)      not null
#  password_salt        :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  oauth_uid            :string(255)
#  admin                :boolean          default(FALSE)
#  trusted              :boolean          default(FALSE)
#  login                :string(255)
#  encrypted_password   :string(255)
#  authentication_token :string(255)
#  sign_in_count        :integer          default(0), not null
#  failed_attempts      :integer          default(0), not null
#  last_request_at      :datetime
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_login_ip        :string(255)
#  programs_count       :integer          default(0)
#  interactions_count   :integer          default(0)
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#

