Then(/^there should be a "([^"]*)" season tab$/) do |season|
  find('#seasons ul.tabs').should have_content(season) #Then "I should see \"#{season}\" within season tabs"
end
Then(/^there should not be a "([^"]*)" season tab$/) do |season|
  find('ul.tabs li').should_not have_content(season) #Then "I should not see \"#{season}\" within season tabs"
end
Then(/^there should be a "([^"]*)" hidden season tab$/) do |season|
  find('ul.tabs li:hidden').should have_content(season) #Then "I should see \"#{season}\" within hidden season tabs"
end
Then /^(.+) has (\d+) seasons$/ do |model_name, seasons|
  m = model(model_name)
  m.max_season_nr= seasons.to_i
  m.save
end