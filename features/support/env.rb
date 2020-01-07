require 'selenium-webdriver'
require 'cucumber'
require 'logger'
require 'rspec'

@@url = 'https://www.upwork.com/'
@@logger = Logger.new("myDevelopmentLogs.txt")
@@logger = Logger.new(STDOUT)

