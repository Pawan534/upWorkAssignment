# Cucumber-Ruby-Selenium Upwork sample Project 

This is Upwork sample project that how we can write test cases/scenario in cucumber and implement the test case using Ruby Language using selenium Webdriver. 

# Test Environment
- Cucumber Framework
- Ruby Language
- RubyMine IDE
- Selenium Webdriver

# How to run the project
- open terminal (cmd) and run the following commands 
     -gem install selenium-webdriver -v 2.53.0
     - gem install cucumber
     - gem install logger
     - gem install rspec
     
- Download Mozilla Firefox too to run this project
- open the IDE(RubyMine)
- open the project using file tab--> open --> select project
- select the language - Ruby from preferences --> language and framework
- You can run the project in 2 ways 
   Using  terminal :
    - cucumber -t @tag
    
    OR
    
    - go to upWorkSearch.feature file 
    - right click  and click on 'Run Scenario:Search'
    
    - Once the scenarios is executed, we have again 2 cases
       - if the scenario gets failed, we will see the failed scenario screenshot in screenshot folder and html report
       - if the scenario gets passed, we will see onl html report
    