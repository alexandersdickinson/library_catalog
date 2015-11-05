require('rspec')
require('pg')
require('capybara/rspec')
require('author')
require('patron')
require('book')

DB = PG.connect({:dbname => "library_catalog_test"})

RSpec.configure() do |config|
  config.after(:each) do 
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM books *;")
  end
end