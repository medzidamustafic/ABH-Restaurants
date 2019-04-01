require 'capybara'
require 'capybara/rspec'
require 'rspec'
require 'selenium-webdriver'
require 'capybara/selenium/extensions/scroll'

Capybara.default_driver = :selenium_chrome
Capybara.ignore_hidden_elements = false

RSpec.describe 'Smoke test', type: :feature do

  before(:each) do
    visit 'https://abh-restaurants-frontend.herokuapp.com/'
  end

    it 'search restaurant and reserve a table'  do
        fill_in "Location, Restaurant or Cousine", with: 'One Bis' 
        click_on 'Find a table'
        expect(page).to have_xpath('//*[@id="row1"]/div')
        click_on 'Reserve now'
        expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/restaurants/singlePage?name=One%20Bis')
    end
    it 'search Restaurants page'  do
        find_link('Restaurants', href: '/restaurants/search').click
        find(:id, 'searchQuery').set('Sarajevo')
        click_on 'Find a table'
        expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/restaurants/search?query=Sarajevo')
        within('#columns') do
            expect(page).to have_xpath('//*[@id="row1"]')
            expect(page).to have_xpath('//*[@id="row2"]')
            expect(page).to have_xpath('//*[@id="row3"]')
            within('#row1') do
                expect(page).to have_xpath('//*[@id="row1"]/div[1]')
                expect(page).to have_xpath('//*[@id="row1"]/div[2]')
                expect(page).to have_xpath('//*[@id="row1"]/div[3]')
            end 
        end
        expect(page).to have_css('.pageNumbers')
    end
    it 'create account, log in/out' do
        find_link('Log in', href: '/login').click
        find_link('Create Account', href: '/register').click
        find(:id, 'name').set('Hana')
        find(:id, 'last_name').set('Mustafic')
        find(:id, 'email').set('mustafic_m@yahoo.com')
        find(:id, 'phone_num').set('38762322650')
        find(:id, 'country').click
        find('.selectCountry option[value="1"]').select_option
        find(:id, 'city').click
        find('.selectCity option[value="1"]').select_option
        find(:id, 'password').set('Internship123')
        find(:id, 'confirm').set('Internship123')
        find(:id, 'submitRegister').click
        #expect(page).to have_content('Account is created successfully!')
        expect(page).to have_content('User with that email exists!!!')
        find_link('Login', href: '/login').click
        find(:id, 'username').set('mustafic_m@yahoo.com')
        find(:id, 'password').set('Internship123')
        find(:id, 'submitLogin').click
        expect(page).to have_content('Successfully logged in!')
        expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/home')
        find_link('Log out', href: '/login').click
        expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/login')
    end

end    