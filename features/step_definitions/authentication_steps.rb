Given(/^I have a valid user account$/) do
  @user = FactoryGirl.create :user
end

When(/^I authenticate$/) do
  visit root_path
  click_link 'Login'
  within 'form.sign_in' do
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_button 'Login'
  end
end

When(/^I authenticate with invalid credentials$/) do
  visit root_path
  click_link 'Login'
  within 'form.sign_in' do
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: 'invalid'
    click_button 'Login'
  end
end

Then(/^I want to see that I am logged in$/) do
  find('nav.navbar').should have_content @user.login.humanize
end

Then(/^I dont want to be logged in$/) do
  find('nav.navbar').should_not have_content @user.login.humanize
end