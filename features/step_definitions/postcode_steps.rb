Given(/^I access the page for "(.*?)"$/) do |postcode|
  postcode.gsub!(" ", "")
  visit ("/postcode/#{postcode}")
end

Then(/^I should see the following details:$/) do |table|
  table.rows_hash.each do |k,v|
    dd = page.find("dd.#{k}")
    expect(dd).to have_content v
  end
end

Given(/^I access the (.*?) version of "([^"]*)"$/) do |format, postcode|
  postcode.gsub!(" ", "")
  visit ("/postcode/#{postcode}.#{format.downcase}")
end

Given(/^I access the (.*?) version of "(.*?)" with the callback "(.*?)"$/) do |format, postcode, callback|
  @callback = callback
  @postcode = postcode
  postcode.gsub!(" ", "")
  visit ("/postcode/#{postcode}.#{format.downcase}?callback=#{@callback}")
end

Then(/^I should see the correct callback$/) do
  page.body.should match /#{@callback}/
end

Then(/^I should be redirected to the JSONP version of the data$/) do
  page.current_url.should == "http://www.example.com/postcode/#{@postcode}.jsonp?callback=#{@callback}"
end

Then(/^I should see the following json:$/) do |string|
  JSON.parse(page.body).should eql(JSON.parse(string.squish))
end

Then(/^I should see the following xml|rdf|csv:$/) do |string|
  page.body.squish.should eql string.squish
end

Given(/^I try and access the page for "(.*?)" with a space$/) do |postcode|
  @postcode = postcode
  visit ("/postcode/#{URI.escape(@postcode)}")
end

Then(/^I should be redirected to the canonical URL for the postcode$/) do
  postcode = @postcode.gsub(" ", "")
  page.current_path.should eql "/postcode/#{postcode}.html"
end

Then(/^the response should be "(.*?)"$/) do |code|
  page.status_code.should == code.to_i
end

Then(/^I should see the error "(.*?)"$/) do |error|
  page.should have_content error
end

