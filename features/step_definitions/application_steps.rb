Then /^I wait (for)? (\d+) seconds$/ do |arg1, time|
  sleep time.to_i
end

Then /^I take a screenshot$/ do
  page.driver.browser.save_screenshot("screenshot#{Time.now.to_i}.png" )
end
