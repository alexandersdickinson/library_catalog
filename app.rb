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
  erb(:patron)
end

get('/search_patrons') do
  @header = 'Search Patrons'
  erb(:search_patrons)
end

get('/patron_search_results') do
  @header = "Found Patrons"
  search_criteria = {}
  search_criteria[:last_name] = params.fetch('last-name') if params.fetch('last-name').length() > 0
  search_criteria[:first_name] = params.fetch('first-name') if params.fetch('first-name').length() > 0
  @patrons = Patron.search_by(search_criteria)
  erb(:patron_results)
end

get('/patrons/:id') do
  @patron = Patron.find(params.fetch('id').to_i())
  @header = "#{@patron.last_name()}, #{@patron.first_name()}"
  erb(:patron)
end

delete('/patrons/delete_success') do
  @header = "Library Catalog"
  patron = Patron.find(params.fetch('patron-id').to_i())
  patron.delete()
  @message = "#{patron.last_name()}, #{patron.first_name()} successfully deleted."
  erb(:index)
end

get('/patrons/:id/edit') do
  @patron = Patron.find(params.fetch('id').to_i())
  @header = "Edit #{@patron.last_name()}, #{@patron.first_name()}"
  erb(:update_patron)
end

patch('/patrons/:id') do
  @patron = Patron.find(params.fetch('patron-id').to_i())
  @patron.update({:last_name => params.fetch('last-name'), :first_name => params.fetch('first-name')})
  @header = "#{@patron.last_name()}, #{@patron.first_name()}"
  erb(:patron)
end

get('/add_patron') do
  @header = "Add Patron"
  erb(:patron_form)
end