require('spec_helper')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('the patron creation path', :type => :feature) do
  it('adds a patron') do
    visit('/')
    click_link('Add Patron')
    fill_in('last-name', :with => "Smith")
    fill_in('first-name', :with => "John")
    click_button('New Patron')
    expect(page).to(have_content("Smith, John"))
  end
end

describe('the patron search path', :type => :feature) do
  it('returns patrons found by one criterion') do
    patron1 = Patron.new({:last_name => "Smith", :first_name => "John", :id => nil})
    patron2 = Patron.new({:last_name => "Smith", :first_name => "Ralph", :id => nil})
    patron1.save()
    patron2.save()
    visit('/')
    click_link('Search Patrons')
    fill_in('last-name', :with => "Smith")
    click_button('Search')
    expect(page).to(have_content("Smith, John"))
    expect(page).to(have_content("Smith, Ralph"))
  end
  
  it('returns patrons found by multiple criteria') do
    patron1 = Patron.new({:last_name => "Smith", :first_name => "John", :id => nil})
    patron2 = Patron.new({:last_name => "Smith", :first_name => "Ralph", :id => nil})
    patron1.save()
    patron2.save()
    visit('/')
    click_link('Search Patrons')
    fill_in('last-name', :with => "Smith")
    fill_in('first-name', :with => "John")
    click_button('Search')
    expect(page).to(have_content("Smith, John"))
  end
  
  it('tells the user when no patrons are found') do
    visit('/')
    click_link('Search Patrons')
    fill_in('last-name', :with => "Smith")
    fill_in('first-name', :with => "John")
    click_button('Search')
    expect(page).to(have_content("No patrons found."))
  end
end

describe('the patron deletion path', :type => :feature) do
  it('displays a message confirming patron deletion') do
    patron = Patron.new({:last_name => "Smith", :first_name => "John", :id => nil})
    patron.save()
    visit('/')
    click_link("Search Patrons")
    fill_in('last-name', :with => "Smith")
    click_button('Search')
    click_link('Smith, John')
    click_button('Delete Patron')
    expect(page).to(have_content("Smith, John successfully deleted"))
  end
  
  it('deletes the patron from the database') do
    patron = Patron.new({:last_name => "Smith", :first_name => "John", :id => nil})
    patron.save()
    visit('/')
    click_link("Search Patrons")
    fill_in('last-name', :with => "Smith")
    click_button('Search')
    click_link('Smith, John')
    click_button('Delete Patron')
    click_link('Search Patrons')
    fill_in('last-name', :with => "Smith")
    expect(page).not_to(have_content("Smith, John"))
  end
end

describe('the patron edit path', :type => :feature) do
  it('edits a patron') do
    patron = Patron.new({:last_name => "Smith", :first_name => "John", :id => nil})
    patron.save()
    visit('/')
    click_link("Search Patrons")
    fill_in('last-name', :with => "Smith")
    click_button('Search')
    click_link('Smith, John')
    click_link('Edit Patron')
    fill_in('last-name', :with => "Doe")
    fill_in('first-name', :with => "Jane")
    click_button('Edit Patron')
    expect(page).to(have_content("Doe, Jane"))
  end
end

describe('the author creation path', :type => :feature) do
  it('adds an author') do
    visit('/')
    click_link('Add Author')
    fill_in('last-name', :with => "James")
    fill_in('first-name', :with => "Montague")
    click_button('New Author')
    expect(page).to(have_content("James, Montague"))
  end
end

describe('the author search path', :type => :feature) do
  it('returns authors found by one criterion') do
    author1 = Author.new({:last_name => "Smith", :first_name => "John", :id => nil})
    author2 = Author.new({:last_name => "Smith", :first_name => "Ralph", :id => nil})
    author1.save()
    author2.save()
    visit('/')
    click_link('Search Authors')
    fill_in('last-name', :with => "Smith")
    click_button('Search')
    expect(page).to(have_content("Smith, John"))
    expect(page).to(have_content("Smith, Ralph"))
  end
  
  it('returns authors found by multiple criteria') do
    author1 = Author.new({:last_name => "Smith", :first_name => "John", :id => nil})
    author2 = Author.new({:last_name => "Smith", :first_name => "Ralph", :id => nil})
    author1.save()
    author2.save()
    visit('/')
    click_link('Search Authors')
    fill_in('last-name', :with => "Smith")
    fill_in('first-name', :with => "John")
    click_button('Search')
    expect(page).to(have_content("Smith, John"))
  end
  
  it('tells the user when no authors are found') do
    visit('/')
    click_link('Search Authors')
    fill_in('last-name', :with => "Smith")
    fill_in('first-name', :with => "John")
    click_button('Search')
    expect(page).to(have_content("No authors found."))
  end
end