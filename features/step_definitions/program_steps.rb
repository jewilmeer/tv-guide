Then(/^there should be a "([^"]*)" season tab$/) do |season|
  find('ul.tabs li').should have_content(season) #Then "I should see \"#{season}\" within season tabs"
end
Then(/^there should not be a "([^"]*)" season tab$/) do |season|
  find('ul.tabs li').should_not have_content(season) #Then "I should not see \"#{season}\" within season tabs"
end
Then(/^there should be a "([^"]*)" hidden season tab$/) do |season|
  find('ul.tabs li:hidden').should have_content(season) #Then "I should see \"#{season}\" within hidden season tabs"
end
Then /^(.+) has (\d+) seasons$/ do |model_name, seasons|
  model(model_name).max_season_nr= seasons.to_i
end