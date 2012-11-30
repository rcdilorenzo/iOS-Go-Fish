require 'calabash-cucumber/calabash_steps'

Given /^I am on the Startup Screen$/ do
  element_exists("view")
  sleep(STEP_PAUSE)
end

Then /^I should see cards on the screen$/ do
  element_exists("Card")
end

Then /^I see (\w+)'s game in its initial state$/ do |name|
  macro %Q[I wait to see a navigation bar titled "Go Fish"]
  macro %Q[I should see "#{name} - 0 Books"]
  macro %Q[I should see cards on the screen]
end

Given /^I.*[created|started|create|start|made|make].*game.*"(\w+)".*$/ do |name|
  element_exists("view")
  sleep(STEP_PAUSE)
  macro %Q[I fill in "Player Name" with "#{name}"]
  macro %Q[I touch "Start"]
  macro %Q[I wait to see a navigation bar titled "Go Fish"]
  macro %Q[I should see "#{name} - 0 Books"]
  macro %Q[I should see cards on the screen]
end

Then /I.*see.+default.*[robot|player].*names: (.*)$/ do |player_names|
  player_name_array = player_names.split(", ")
  player_name_array.each do |player_name|
    macro %Q[I should see "#{player_name}"]
  end
end
