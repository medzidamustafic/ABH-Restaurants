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

  it 'find free tables/reserve tables' do
    fill_in "Location, Restaurant or Cousine", with: 'Mrvica' 
    click_on 'Find a table'
    expect(page).to have_xpath('//*[@id="row1"]/div')
    click_on 'Reserve now'
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/restaurants/singlePage?name=Mrvica')
    find(:id, 'country').set('3')
    find(:id, 'datepicker').set('04/21/2019')
    find(:id, 'find').click
    expect(page).to have_content('Please log in to proceed!')
    expect(page).to have_xpath('//*[@id="reservationQuery"]')
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
    expect(page).to have_xpath('//*[@id="ratedYet"]')
    expect(page).to have_xpath('//*[@id="reservedYet"]')
    find(:id, 'country').set('6')
    find(:id, 'datepicker').set('04/21/2019')
    find(:id, 'find').click
    expect(page).to have_xpath('//*[@id="reservationQuery"]')
    expect(page).to have_xpath('//*[@id="tablesLeft"]')
    find_button('Reserve now').click
    expect(page).to have_content('Reservation successfully completed!')
    page.execute_script("window.location.reload()")
    expect(page).to have_xpath('//*[@id="reservedYet"]')
    find(:id, 'country').set('7')
    find(:id, 'datepicker').set('04/23/2019')
    find(:id, 'find').click
    #expect(page).to have_content('You already made a reservation for this table!')
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
    expect(page).to have_xpath('//*[@id="description"]')
    find_link('Menu', href:'#menu_meals').click
    expect(page).to have_css('.breakfast')
    find('.lunchButton').click
    expect(page).to have_css('.lunch')
    find('.dinnerButton').click
    expect(page).to have_css('.dinner')
    find_link('Photos', href:'#restaurant_photos').click
    expect(page).to have_content('Restaurant photo')
  end

  it 'create account; log in/out' do
    find_link('Log in', href: '/login').click
    find_link('Create Account', href: '/register').click
    find(:id, 'name').set('Hana')
    find(:id, 'last_name').set('Mustafic')
    find(:id, 'email').set('haannaa_mustafic@gmail.com')
    find(:id, 'phone_num').set('38762322650')
    find(:id, 'country').click
    find('.selectCountry option[value="1"]').select_option
    find(:id, 'city').click
    find('.selectCity option[value="1"]').select_option
    find(:id, 'password').set('Internship123')
    find(:id, 'confirm').set('Internship123')
    find(:id, 'submitRegister').click
    expect(page).to have_content('Account successfully created!')
    sleep(3)
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/login')
    sleep(2)
    find(:id, 'username').set('haannaa_mustafic@gmail.com')
    find(:id, 'password').set('Internship123')
    find(:id, 'submitLogin').click
    expect(page).to have_content('Successfully logged in!')
    sleep(3)
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/home')
    find_link('Log out', href: '/login').click
    sleep(2)
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/login')
  end

  it 'user cannot crate more than one account with the same email' do
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
  end

  it 'disabled login with invalid data' do
    find_link('Log in', href: '/login').click
    find(:id, 'username').set('denana84@gmail.com')
    find(:id, 'password').set('Internship123')
    find(:id, 'submitLogin').click
    expect(page).to have_content("Account doesn't exist!")
    find(:id, 'username').set('medzidamustaficgmail.com')
    find(:id, 'password').set('Hugolina1')
    find(:id, 'submitLogin').click
    expect(page).to have_content('Wrong email or password!')
    find(:id, 'username').set('medzidamustafic@gmail.com')
    find(:id, 'password').set('12345')
    find(:id, 'submitLogin').click
    expect(page).to have_content('Wrong email or password!')
  end

  it 'create account with invalid data/password confirmation' do
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
    expect(page).to have_content('Invalid email format entered!')
    find(:id, 'email').set('denana_p@gmail.com')
    find(:id, 'password').set('Internship')
    find(:id, 'confirm').set('Internship')
    find(:id, 'submitRegister').click
    expect(page).to have_content('Password must contain at least one upper case letter, one lower case letter and one number!')
    find(:id, 'email').set('denana84@gmail.com')
    find(:id, 'password').set('Internship123')
    find(:id, 'confirm').set('Intern12')
    find(:id, 'submitRegister').click
    expect(page).to have_content('Different passwords entered!')
    find(:id, 'name').set('Dzenana23$%&')
    find(:id, 'confirm').set('Internship123')
    find(:id, 'submitRegister').click
    expect(page).to have_content('Invalid name entered!')
    find(:id, 'name').set('Dzenana')
    find(:id, 'last_name').set('Pozderac$%&/')
    find(:id, 'submitRegister').click
    expect(page).to have_content('Invalid last name entered!')
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
    find(:id, 'username').set('hn_mmusttafiic@yahoo.com')
    find(:id, 'password').set('Internship123')
    find(:id, 'submitLogin').click
    expect(page).to have_content('Successfully logged in!')
    sleep(4)
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/home')
    fill_in "Location, Restaurant or Cousine", with: 'Plaža' 
    click_on 'Find a table'
    expect(page).to have_xpath('//*[@id="row1"]/div')
    click_on 'Reserve now'
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/restaurants/singlePage?name=Plaža')
    find(:id, 'ratePlace').click
    find(:xpath, '/html/body/div[4]/div/div[1]/span[1]').click
    find('#reviewText').set('Bad location!')
    find('.saveReview').click
    page.execute_script("window.location.reload()")
    expect(page).to have_xpath('//*[@id="ratedYet"]')
    find(:id, 'ratePlace').click
    expect(page).to have_content('You already rated this restaurant')
  end
  
  it 'view Specials gallery' do
    execute_script("arguments[0].scrollIntoView();", page.find('#specials', visible: false))
    expect(page).to have_content('Specials')
    expect(page).to have_xpath('//*[@id="imgClickAndChange"]')
    find(:id, 'rightArrow').click
    #expect(page.find('#imgClickAndChange')['src']).to have_content '/assets/images/dessert_image.jpg' 
    expect(page).to have_content('Choco pancakes')
    find(:id, 'leftArrow').click
    #expect(page.find('#imgClickAndChange')['src']).to have_content '/assets/images/Pizza-capricciosa.jpg' 
    expect(page).to have_content('Best pizza of 2016')
  end

  it 'filter restaurants' do
    find_link('Restaurants', href: '/restaurants/search').click
    find(:id, 'searchQuery').set('Sarajevo')
    click_on 'Find a table'
    expect(page).to have_current_path('https://abh-restaurants-frontend.herokuapp.com/restaurants/search?query=Sarajevo')
    find('.selectBox').click
    find(:xpath, '//*[@id="checkboxes"]/label[1]/input').check
    click_on 'Find a table'
    within('#row1') do
      expect(page).to have_content('Sendi')
      expect(page).to have_content('Kimono')  
    end 
  end
end