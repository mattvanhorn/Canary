When /^I am not signed in$/ do 
  visit sign_out_path
end

When /^I sign in$/ do
  visit sign_in_path
  fill_in I18n.t('sign_in.auth_key'), :with => 'alice@example.com'
  fill_in I18n.t('sign_in.password'), :with => 'password'
  click_on I18n.t('sign_in.submit')
end

When /^I sign in with no credentials$/ do
  visit sign_in_path
  click_on I18n.t('sign_in.submit')
end

When /^I sign in with no password$/ do
  visit sign_in_path
  fill_in I18n.t('sign_in.auth_key'), :with => 'alice@example.com'
  click_on I18n.t('sign_in.submit')
end

When /^I sign in with no email$/ do
  visit sign_in_path
  fill_in I18n.t('sign_in.password'), :with => 'password'
  click_on I18n.t('sign_in.submit')
end

When /^I sign in with bad credentials$/ do
  Identity.where(:email => 'no-such-user@example.com').should be_empty
  visit sign_in_path
  fill_in I18n.t('sign_in.auth_key'), :with => 'no-such-user@example.com'
  fill_in I18n.t('sign_in.password'), :with => 'bad-password'
  click_on I18n.t('sign_in.submit')
end
