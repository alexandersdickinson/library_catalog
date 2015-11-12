require('sinatra')
require('sinatra/reloader')
require('pg')
require('./lib/book')
require('./lib/patron')
require('./lib/author')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => 'library_catalog_test'})

get('/') do
  @header = "Library Catalog"
  @patrons = Patron.all()
  erb(:index)
end

post('/patrons/new') do
  @patron = Patron.new({:last_name => params.fetch('last-name'), :first_name => params.fetch('first-name'), :id => nil})
  @patron.save()
  @header = "#{@patron.last_name()}, #{@patron.first_name()}"
  @books = @patron.books()
  erb(:patron)
end

post('/authors/new') do
  @author = Author.new({:last_name => params.fetch('last-name'), :first_name => params.fetch('first-name'), :id => nil})
  @books = []
  @author.save()
  @header = "#{@author.last_name()}, #{@author.first_name()}"
  erb(:author)
end

post('/authors/:id/books/new') do
  @author = Author.find(params.fetch('id').to_i())
  @book = Book.new(:title => params.fetch('title'), :checkout => Date.new(1900, 1, 1), :is_checked_out => false, :author_id => @author.id(), :patron_id => 0, :id => nil)
  @book.save()
  @books = Book.search_by({:last_name => @author.last_name(), :first_name => @author.first_name()})
  @header = "#{@author.last_name()}, #{@author.first_name()}"
  @header = "New Book"
  erb(:author)
end

get('/search_patrons') do
  @header = 'Search Patrons'
  erb(:search_patrons)
end

get('/search_authors') do
  @header = 'Search Authors'
  erb(:search_authors)
end

get('/search_books') do
  @header = 'Search Books'
  @action = '/book_search_results'
  erb(:search_books)
end

get('/patrons/:id/search_books') do
  @header = 'Search Books'
  @action = "/patrons/#{params.fetch('id').to_i()}/book_search_results"
  erb(:search_books)
end

get('/patron_search_results') do
  @header = "Found Patrons"
  search_criteria = {}
  search_criteria[:last_name] = params.fetch('last-name') if params.fetch('last-name').length() > 0
  search_criteria[:first_name] = params.fetch('first-name') if params.fetch('first-name').length() > 0
  @patrons = Patron.search_by(search_criteria)
  erb(:patron_results)
end

get('/author_search_results') do
  @header = "Found Authors"
  search_criteria = {}
  search_criteria[:last_name] = params.fetch('last-name') if params.fetch('last-name').length() > 0
  search_criteria[:first_name] = params.fetch('first-name') if params.fetch('first-name').length() > 0
  @authors = Author.search_by(search_criteria)
  erb(:author_results)
end

get('/book_search_results') do
  @header = "Found Books"
  search_criteria = {}
  search_criteria[:last_name] = params.fetch('last-name') if params.fetch('last-name').length() > 0
  search_criteria[:first_name] = params.fetch('first-name') if params.fetch('first-name').length() > 0
  search_criteria[:title] = params.fetch('title') if params.fetch('title').length() > 0
  @books = Book.search_by(search_criteria)
  erb(:book_results)
end

get('/patrons/:id/book_search_results') do
  @header = 'Found Books'
  search_criteria = {}
  search_criteria[:last_name] = params.fetch('last-name') if params.fetch('last-name').length() > 0
  search_criteria[:first_name] = params.fetch('first-name') if params.fetch('first-name').length() > 0
  search_criteria[:title] = params.fetch('title') if params.fetch('title').length() > 0
  search_criteria[:is_checked_out] = false
  @patron = Patron.find(params.fetch('id').to_i())
  @books = Book.search_by(search_criteria)
  erb(:book_checkout_results)
end

patch('/patrons/:id/checkout') do
  @patron = Patron.find(params.fetch('id').to_i())
  @header = "#{@patron.last_name()}, #{@patron.first_name()}"
  book = Book.find(params.fetch('book-id').to_i())
  @patron.check_out(book)
  @books = @patron.books()
  erb(:patron)
end

patch('/patrons/:id/return') do
  @patron = Patron.find(params.fetch('id').to_i())
  @header = "#{@patron.last_name()}, #{@patron.first_name()}"
  book = Book.find(params.fetch('book-id').to_i())
  @patron.return(book)
  @books = @patron.books()
  erb(:patron)
end

get('/patrons/:id') do
  @patron = Patron.find(params.fetch('id').to_i())
  @header = "#{@patron.last_name()}, #{@patron.first_name()}"
  @books = @patron.books()
  erb(:patron)
end

get('/authors/:id') do
  @author = Author.find(params.fetch('id').to_i())
  @books = Book.search_by({:last_name => @author.last_name(), :first_name => @author.first_name()})
  @header = "#{@author.last_name()}, #{@author.first_name()}"
  erb(:author)
end

delete('/patrons/delete_success') do
  @header = "Library Catalog"
  patron = Patron.find(params.fetch('patron-id').to_i())
  patron.delete()
  @message = "#{patron.last_name()}, #{patron.first_name()} successfully deleted."
  erb(:index)
end

delete('/authors/delete_success') do
  @header = "Library Catalog"
  author = Author.find(params.fetch('author-id').to_i())
  author.delete()
  @message = "#{author.last_name()}, #{author.first_name()} successfully deleted."
  erb(:index)
end

get('/patrons/:id/edit') do
  @patron = Patron.find(params.fetch('id').to_i())
  @header = "Edit #{@patron.last_name()}, #{@patron.first_name()}"
  erb(:update_patron)
end

get('/authors/:id/edit') do
  @author = Author.find(params.fetch('id').to_i())
  @header = "Edit #{@author.last_name()}, #{@author.first_name()}"
  erb(:update_author)
end

patch('/patrons/:id') do
  @patron = Patron.find(params.fetch('patron-id').to_i())
  @patron.update({:last_name => params.fetch('last-name'), :first_name => params.fetch('first-name')})
  @header = "#{@patron.last_name()}, #{@patron.first_name()}"
  @books = @patron.books()
  erb(:patron)
end

patch('/authors/:id') do
  @author = Author.find(params.fetch('author-id').to_i())
  @books = Book.search_by({:last_name => @author.last_name(), :first_name => @author.first_name()})
  @author.update({:last_name => params.fetch('last-name'), :first_name => params.fetch('first-name')})
  @header = "#{@author.last_name()}, #{@author.first_name()}"
  erb(:author)
end

get('/add_patron') do
  @header = "Add Patron"
  erb(:patron_form)
end

get('/add_author') do
  @header = "Add Author"
  erb(:author_form)
end