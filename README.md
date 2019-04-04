# ABH-Restaurants
https://abh-restaurants-frontend.herokuapp.com
## Resources:

    https://abh-restaurants-frontend.herokuapp.com

    Project management tool: Trello

    Trello boards: https://trello.com/b/JPIKzeia/testing-internship-3-q12019
    
                  https://trello.com/b/B0AfO376/development-internship-1-q12019
    
## Description

In this repository Smoke test for ABH Restaurants App is automated using test automation tools described in Environment setup section.

Test script contains following test cases: 

    - User can open landing page and search for the restaurant 
    - User is able to create an account
    - User is able to log in with an exisisting account
    - User is able to search for the list of the restaurants on the 'Restaurants' page
    - User is able to log out
    - User is able to reserve table in restaurant


## Environment setup: 

#### Install Linux/Ubuntu 16.04.

#### Ruby  
          
       Download and install ruby (link: https://rubyinstaller.org/downloads/)

#### RSpec

       Install `gem install rspec`

       Setup `rspec --init`
       
#### Capybara 
            
        Capybara requires Ruby 2.3.0 or later. 

        To install, add this line to `Gemfile` and run `bundle install`:  `gem 'capybara'`, 'regression_test.rb'

        In the application:

                   `require 'capybara'`
                   
                   `require 'capybara/rspec'`


#### Selenium
     
       In order to use Selenium, install the `selenium-webdriver` gem, and add it to `Gemfile`.
       
       Make Capybara run tests in Selenium by setting `Capybara.default_driver = :selenium`
       
              
          
#### Run test script

       Run test script by entering: `rspec smoke_test.rb`
