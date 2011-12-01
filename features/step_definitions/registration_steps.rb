When /^I submit my valid registration information$/ do
  fill_in 'Email', :with => 'user@example.com'
  fill_in 'Password', :with => 'foobar'
  fill_in 'Confirm Password', :with => 'foobar'
  click_on 'Connect'
end

When /^I have an account$/ do
  Fabricate(:identity, :email => 'alice@example.com')
end
