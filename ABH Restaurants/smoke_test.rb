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

    it 'create account; log in/out' do
        find_link('Log in', href: '/login').click
        find_link('Create Account', href: '/register').click
        find(:id, 'name').set('Hana')
        find(:id, 'last_name').set('Mustafic')
        find(:id, 'email').set('hn_mmusttafiic@yahoo.com')
        find(:id, 'phone_num').set('38762322650')
        find(:id, 'country').click
        find('.selectCountry option[value="1"]').select_option
        find(:id, 'city').click
        find('.selectCity option[value="1"]').select_option
        find(:id, 'password').set('Internship123')
        find(:id, 'confirm').set('Internship123')
        find(:id, 'submitRegister').click
        expect(page).to have_content('Account successfully created!')
        sleep(4)
        find(:id, 'username').set('hn_mmusttafiic@yahoo.com')
        find(:id, 'password').set('Internship123')
        find(:id, 'submitLogin').click
        expect(page).to have_content('Successfully logged in!')
        sleep(3)
        expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/home')
        find_link('Log out', href: '/login').click
        expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/login')
    end

    it 'search restaurant and reserve a table'  do
        find_link('Log in', href: '/login').click
        find(:id, 'username').set('h_mmusttafiic@yahoo.com')
        find(:id, 'password').set('Internship123')
        find(:id, 'submitLogin').click
        expect(page).to have_content('Successfully logged in!')
        sleep(3)
        expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/home')
        fill_in "Location, Restaurant or Cousine", with: 'Mrvica' 
        click_on 'Find a table'
        expect(page).to have_xpath('//*[@id="row1"]/div')
        click_on 'Reserve now'
        expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/restaurants/singlePage?name=Mrvica')
        expect(page).to have_xpath('//*[@id="ratedYet"]')
        expect(page).to have_xpath('//*[@id="reservedYet"]')
        find(:id, 'country').set('6')
        find(:id, 'datepicker').set('04/28/2019')
        find(:id, 'find').click
        expect(page).to have_xpath('//*[@id="reservationQuery"]')
        expect(page).to have_xpath('//*[@id="tablesLeft"]')
        find_button('Reserve now').click
        expect(page).to have_content('Reservation successfully completed!')
        page.execute_script("window.location.reload()")
        expect(page).to have_xpath('//*[@id="reservedYet"]')
        find_link('Log out', href: '/login').click
        expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/login')
        
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

end    