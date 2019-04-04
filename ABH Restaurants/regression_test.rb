require 'capybara'
require 'capybara/rspec'
require 'rspec'
require 'selenium-webdriver'
require 'capybara/selenium/extensions/scroll'

Capybara.default_driver = :selenium_chrome
Capybara.ignore_hidden_elements = false

RSpec.describe 'Regression test', type: :feature do

  before(:each) do
    visit 'https://abh-restaurants-frontend.herokuapp.com/'
  end

  it 'find free tables before and after login' do
    fill_in "Location, Restaurant or Cousine", with: 'Mrvica' 
    click_on 'Find a table'
    expect(page).to have_xpath('//*[@id="row1"]/div')
    click_on 'Reserve now'
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/restaurants/singlePage?name=Mrvica')
    find(:id, 'country').click
    find(:xpath, '//*[@id="country"]/option[2]').click
    click_on 'Find a table'
    expect(page).to have_content("You haven't reserved any tables yet.")
    expect(page).to have_content('Please log in to proceed!')
    find_link('Log in', href: '/login').click
    find(:id, 'username').set('medzidamustafic@gmail.com')
    find(:id, 'password').set('Hugolina1')
    find(:id, 'submitLogin').click
    expect(page).to have_content('Successfully logged in!')
    sleep(3)
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/home')
    fill_in "Location, Restaurant or Cousine", with: 'Mrvica' 
    click_on 'Find a table'
    expect(page).to have_xpath('//*[@id="row1"]/div')
    click_on 'Reserve now'
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/restaurants/singlePage?name=Mrvica')
    expect(page).to have_content("You haven't reserved any tables yet.")
    find(:id, 'country').click
    find(:xpath, '//*[@id="country"]/option[2]').click
    click_on 'Find a table'
    expect(page).to have_xpath('//*[@id="reservationQuery"]')
    expect(page).to have_xpath('//*[@id="tablesLeft"]')
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

  it 'About, Menu and Photos' do
    fill_in "Location, Restaurant or Cousine", with: 'Mrvica' 
    click_on 'Find a table'
    expect(page).to have_xpath('//*[@id="row1"]/div')
    click_on 'Reserve now'
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/restaurants/singlePage?name=Mrvica')
    find_link('About', href:'#about_res').click
    expect(page).to have_xpath('//*[@id="gmap_canvas"]')
    sleep(3)
    expect(page).to have_xpath('//*[@id="description"]')
    sleep(2)
    find_link('Menu', href:'#menu_meals').click
    sleep(3)
    expect(page).to have_css('.breakfast')
    find('.lunchButton').click
    sleep(3)
    expect(page).to have_css('.lunch')
    find('.dinnerButton').click
    sleep(2)
    expect(page).to have_css('.dinner')
    find_link('Photos', href:'#restaurant_photos').click
    sleep(2)
    expect(page).to have_content('Restaurant photo')
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
    find_link('Login', href: '/login').click
    find(:id, 'username').set('mustafic_m@yahoo.com')
    find(:id, 'password').set('Internship123')
    find(:id, 'submitLogin').click
    expect(page).to have_content('Successfully logged in!')
    sleep(3)
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/home')
    find_link('Log out', href: '/login').click
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/login')
  end

  it 'User cannot crate more than one account with the same email' do
    find_link('Log in', href: '/login').click
    find_link('Create Account', href: '/register').click
    find(:id, 'name').set('Hana')
    find(:id, 'last_name').set('Mustafic')
    find(:id, 'email').set('medzidamustafic@gmail.com')
    find(:id, 'phone_num').set('38762322650')
    find(:id, 'country').click
    find('.selectCountry option[value="1"]').select_option
    find(:id, 'city').click
    find('.selectCity option[value="1"]').select_option
    find(:id, 'password').set('Internship1')
    find(:id, 'confirm').set('Internship1')
    find(:id, 'submitRegister').click
    expect(page).to have_content('User with that email exists!!!')
    sleep(3)
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

  it 'Disabled login with invalid data' do
    find_link('Log in', href: '/login').click
    find(:id, 'username').set('denana84@gmail.com')
    find(:id, 'password').set('Internship123')
    find(:id, 'submitLogin').click
    sleep(3)
    expect(page).to have_content("Account doesn't exist!")
    find(:id, 'username').set('medzidamustaficgmail.com')
    find(:id, 'password').set('Hugolina1')
    find(:id, 'submitLogin').click
    sleep(3)
    expect(page).to have_content('Wrong email or password!')
    find(:id, 'username').set('medzidamustafic@gmail.com')
    find(:id, 'password').set('12345')
    find(:id, 'submitLogin').click
    sleep(3)
    expect(page).to have_content('Wrong email or password!')
  end

  it 'create account with invalid data, password confirmation' do
    find_link('Log in', href: '/login').click
    find_link('Create Account', href: '/register').click
    find(:id, 'name').set('Dzenana')
    find(:id, 'last_name').set('Pozderac')
    find(:id, 'email').set('denana84@.com')
    find(:id, 'phone_num').set('38762322650')
    find(:id, 'country').click
    find('.selectCountry option[value="1"]').select_option
    find(:id, 'city').click
    find('.selectCity option[value="1"]').select_option
    find(:id, 'password').set('Internship123')
    find(:id, 'confirm').set('Internship123')
    find(:id, 'submitRegister').click
    sleep(2)
    expect(page).to have_content('Invalid email format entered!')
    sleep(3)
    find(:id, 'email').set('denana_p@gmail.com')
    find(:id, 'password').set('Internship')
    find(:id, 'confirm').set('Internship')
    find(:id, 'submitRegister').click
    expect(page).to have_content('Password must contain at least one upper case letter, one lower case letter and one number!')
    sleep(3)
    find(:id, 'email').set('denana84@gmail.com')
    find(:id, 'password').set('Internship123')
    find(:id, 'confirm').set('Intern12')
    find(:id, 'submitRegister').click
    sleep(3)
    expect(page).to have_content('Different passwords entered!')
  end

  it 'rate the restaurant when logged in/out' do
    fill_in "Location, Restaurant or Cousine", with: 'Apetit' 
    click_on 'Find a table'
    expect(page).to have_xpath('//*[@id="row1"]/div')
    click_on 'Reserve now'
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/restaurants/singlePage?name=Apetit')
    find(:id, 'ratePlace').click
    expect(page).to have_content('Please log in to proceed!')
    find_link('Log in', href: '/login').click
    find(:id, 'username').set('medzidamustafic@gmail.com')
    find(:id, 'password').set('Hugolina1')
    find(:id, 'submitLogin').click
    expect(page).to have_content('Successfully logged in!')
    sleep(3)
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/home')
    fill_in "Location, Restaurant or Cousine", with: 'Apetit' 
    click_on 'Find a table'
    expect(page).to have_xpath('//*[@id="row1"]/div')
    click_on 'Reserve now'
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/restaurants/singlePage?name=Apetit')
    find(:id, 'ratePlace').click
    find(:xpath, '/html/body/div[4]/div/div[1]/span[1]').click
    find('#reviewText').set('Bad location!')
    find('.saveReview').click
    sleep(3)
    page.execute_script("window.location.reload()")
    expect(page).to have_content('Your review: 1/5')
    find(:id, 'ratePlace').click
    expect(page).to have_content('You already rated this restaurant')
    sleep(3)
  end
  
  it 'Specials gallery' do
    execute_script("arguments[0].scrollIntoView();", page.find('#specials', visible: false))
    expect(page).to have_content('Specials')
    expect(page).to have_xpath('//*[@id="imgClickAndChange"]')
    sleep(3)
    find(:id, 'rightArrow').click
    #expect(page.find('#imgClickAndChange')['src']).to have_content '/assets/images/dessert_image.jpg' 
    expect(page).to have_content('Choco pancakes')
    sleep(3)
    find(:id, 'leftArrow').click
    #expect(page.find('#imgClickAndChange')['src']).to have_content '/assets/images/Pizza-capricciosa.jpg' 
    expect(page).to have_content('Best pizza of 2016')
    sleep(3)
  end
end