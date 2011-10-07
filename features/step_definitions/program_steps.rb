Then(/^There should be a "([^"]*)" season tab$/) do |season|
  Then "I should see \"#{season}\" within season tabs"
end
Then(/^There should not be a "([^"]*)" season tab$/) do |season|
  Then "I should not see \"#{season}\" within season tabs"
end
Then(/^There should be a "([^"]*)" hidden season tab$/) do |season|
  Then "I should see \"#{season}\" within hidden season tabs"
end
Then /^(.+) has (\d+) seasons$/ do |model_name, seasons|
  model(model_name).max_season_nr= seasons.to_i
end