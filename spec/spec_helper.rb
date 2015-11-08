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

@@create_patron = lambda do |attributes|
  base = {:last_name => '', :first_name => '', :id => nil}
  base.merge!(attributes)
  Patron.new(base)
end

@@create_author = lambda do |attributes|
  base = {:last_name => "", :first_name => "", :id => nil}
  base.merge!(attributes)
  Author.new(base)
end

@@create_book = lambda do |attributes|
  base = {:title => '', :checkout => Date.new(1919, 5, 8), :author_id => 0, :patron_id => 0, :id => nil}
  base.merge!(attributes)
  Book.new(base)
end