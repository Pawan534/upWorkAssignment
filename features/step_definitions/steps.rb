$userDetails = Hash.new
$selectedUser = Hash.new
$searchKeyWord = ''

Given(/^I visit the upwork home page$/) do
  @@browser.navigate.to @@url
  @@logger.info("Browser is initialized and navigated to given url")
  @@wait.until {
    @@browser.find_element(:class, 'container-visitor')
  }
  element = @@browser.find_element(:css, '.navbar-fixed-top > div:nth-child(1) > div:nth-child(1) > a')
  raise "Test Failed: Logo is not displayed" if !element.displayed?
  @@logger.info("UpWork home page is displayed")
end

And(/^I focus on Find freelancers$/) do
  element = @@browser.find_element(:xpath, '//*[@id="layout"]/up-header-visitor-primary-nav/nav/div/div[2]/div[1]/up-header-search/up-c-on-click-outside/form/div/input[2]')
  sleep 2
  element.send_keys("")
  @@logger.info("Focused on find freelancers search box")
end

When(/^I search the result:$/) do |table|
  $searchKeyWord = table.hashes[0]["keyword"]
  element = @@browser.find_element(:xpath, '//*[@id="layout"]/up-header-visitor-primary-nav/nav/div/div[2]/div[1]/up-header-search/up-c-on-click-outside/form/div/input[2]')
  sleep 2
  element.send_keys($searchKeyWord)
  element = @@browser.find_element(:xpath, '//*[@id="layout"]/up-header-visitor-primary-nav/nav/div/div[2]/div[1]/up-header-search/up-c-on-click-outside/form/div/div/button[1]')
  element.click
  @@logger.info("#{$searchKeyWord} is searched and navigated to expected page")
  @@wait.until {
    @@browser.find_element(:xpath, '//*[@id="main"]/div')
  }
  raise "#{$searchKeyWord} page is not displayed" if !@@browser.title.include? $searchKeyWord
  @@logger.info("#{$searchKeyWord} page is displayed")
end


And(/^I get all the details displayed on the page$/) do
  element = @@browser.find_element(:css, 'div .ng-isolate-scope')
  @@wait.until { element }
  raise 'Search result page is not displayed' if !element.displayed?
  $userDetails = getSearchResults
  raise 'User details are not fetched, empty data fetched' if $userDetails.empty?
  #Below step is verifying the fetched details with keyword
  verifySearchResultWithKeyword($searchKeyWord, $userDetails)
end

Then(/^I click on any random freelancers user profile$/) do
  $selectedUser = $userDetails[rand($userDetails.length)]
  element = $selectedUser[0]["userLink"]
  element.click
  @@logger.info("Selected user: #{$selectedUser} and it has been clicked and redirected to selected page")
end

Then(/^I verify all the user details captured in previous page$/) do
  selectedUserDetails = [
      {"userName" => (@@browser.find_element(:xpath, '//*[@id="optimizely-header-container-default"]/div[1]/div[1]/div/div[2]/h2/span[1]').enabled?) ? @@browser.find_element(:xpath, '//*[@id="optimizely-header-container-default"]/div[1]/div[1]/div/div[2]/h2/span[1]').text : @@browser.find_element(:xpath, '//*[@id="__layout"]/div/div/div[2]/main/div/div[1]/div[3]/div/div[1]/h1').text,
       "jobTitle" => @@browser.find_element(:class, 'fe-job-title').text,
       "userDescription" => @@browser.find_element(:css, '.cfe-overview').text.gsub('\n','').strip,
       "userSkills" => @@browser.find_element(:css, 'cfe-profile-skills-integration.ng-isolate-scope > div:nth-child(1) > div:nth-child(1) > div').text.gsub('\n','').strip
      }]
  #Below we are verifying the user details
  verifySearchResultData(selectedUserDetails, $selectedUser)
end

#Below method is to get the sales details of the user
def getSearchResults
  element = @@browser.find_elements(:css, '.air-card-hover_tile')
  @@wait.until { element }
  search_results = element.map do |ele|
    [{"userName" => ele.find_element(:class, 'freelancer-tile-name').text,
      "jobTitle" => ele.find_element(:class, 'freelancer-tile-title').text,
      "userDescription" => ele.find_element(:class, 'freelancer-tile-description').text.split('...')[0].gsub('\n','').strip,
      "userSkills" => ele.find_element(:class, 'skills-section').text.split(/\d+/)[0].gsub('\n','').gsub('-','').strip,
      "userLink" => ele.find_element(:css, 'a.freelancer-tile-name')}]
  end
  @@logger.info("Searched user details are: #{search_results}")
  search_results
end

#Below method is used to verify the search results contains the given keyword or not
def verifySearchResultWithKeyword(keyword, userData)
  matchFound = false
  for i in 0..userData.length do
    if (userData[i].to_s.include?(keyword))
      matchFound = true
    end
    temp = matchFound ? 'user details matched with keyword ' : 'user details are not matched with keyword'
    @@logger.info("#{userData[i]} #{temp} #{keyword}")
  end
end

#Below method is used to verify the user details
def verifySearchResultData(newDetails, oldDetails)
  puts newDetails
  puts oldDetails
  tempKeys = newDetails[0].keys
  for i in 0..tempKeys.length - 1
    if ((newDetails[0][tempKeys[i]].gsub(/[^0-9A-Za-z]/, '')).include?(oldDetails[0][tempKeys[i]].gsub(/[^0-9A-Za-z]/, '')))
      @@logger.info("#{tempKeys} details are matched")
    else
      raise "#{tempKeys[i]} details are not matched"
    end
  end
end