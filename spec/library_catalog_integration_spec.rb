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

describe('the patron deletion path', :type => :feature) do
  it('deletes a patron') do
    patron = Patron.new({:last_name => "Smith", :first_name => "John", :id => nil})
    patron.save()
    visit('/')
    click_button("delete-smith-john")
    expect(page).not_to(have_content("Smith, John"))
  end
end

describe('the patron edit path', :type => :feature) do
  it('edits a patron') do
    patron = Patron.new({:last_name => "Smith", :first_name => "John", :id => nil})
    patron.save()
    visit('/')
    click_link("update-smith-john")
    fill_in('last-name', :with => "Doe")
    fill_in('first-name', :with => "Jane")
    click_button("Update")
    expect(page).to(have_content("Doe, Jane"))
    expect(page).not_to(have_content("Smith, John"))
  end
end