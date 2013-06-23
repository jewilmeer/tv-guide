Given(/^I am on the registration page$/) do
  visit new_user_registration_path
end

When(/^I enter my user information$/) do
  @user_attributes = FactoryGirl.attributes_for :user
  within 'form.registration' do
    fill_in 'user_email', with: @user_attributes[:email]
    fill_in 'user_password', with: @user_attributes[:password]
    fill_in 'user_password_confirmation', with: @user_attributes[:password]
    fill_in 'user_login', with: @user_attributes[:login]
    click_button 'Sign up'
  end
end

Then(/^I want to be logged in with the created account$/) do
  page.should have_content I18n.t!('devise.registrations.signed_up')
end