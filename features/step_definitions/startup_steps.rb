require 'calabash-cucumber/calabash_steps'

Given /^I am on the Startup Screen$/ do
  element_exists("view")
  sleep(STEP_PAUSE)
end

Then /^I should see cards on the screen$/ do
  element_exists("imageView")
end

Given /^I.*[created|started|create|start|made|making].*game.*"(\w+)".*$/ do |name|
  element_exists("view")
  sleep(STEP_PAUSE)
  macro %Q[I fill in "Name" with "Christian"]
  macro %Q[I touch "Start"]
  macro %Q[I wait to see a navigation bar titled "Go Fish"]
  macro %Q[I should see "#{name}"]
  macro %Q[I should see cards on the screen]
end

Then /I.*see.+default.*[robot|player].*/ do
  macro %Q[I should see "Rack"]
  macro %Q[I should see "Shack"]
  macro %Q[I should see "Benny"]
end
