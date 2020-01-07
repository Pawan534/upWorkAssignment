Before do
  @@browser = Selenium::WebDriver.for :firefox
  @@browser.manage.window.maximize
  @@wait = Selenium::WebDriver::Wait.new(:timeout => 10)
end

#In Below condition, we are capturing the screenshots if scenarios are get failed and closes the browser
After do |scenario|
  begin
    if scenario.failed?
      Dir::mkdir('screenshots') if not File.directory?('screenshots')
      screenshot ="./screenshots/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
      @@browser.save_screenshot(screenshot)
      embed screenshot, 'image/png'
    end
  ensure @@browser.quit
  end
end